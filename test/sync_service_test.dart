import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lorescanner/data/api/lorcana_api.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/sync_service.dart';

import 'fixtures/all_cards_fixture.dart';

const _generatedOn = '2026-07-01T00:00:00Z';

MockClient _client({
  String generatedOn = _generatedOn,
  bool metadataFails = false,
  bool allCardsFails = false,
  void Function(String path)? onRequest,
}) {
  return MockClient((request) async {
    onRequest?.call(request.url.path);
    if (request.url.path.endsWith('metadata.json')) {
      if (metadataFails) return http.Response('gone', 404);
      return http.Response.bytes(
        utf8.encode(jsonEncode({
          'formatVersion': '2.0.0',
          'generatedOn': generatedOn,
          'language': 'de',
        })),
        200,
      );
    }
    if (request.url.path.endsWith('allCards.json')) {
      if (allCardsFails) return http.Response('gone', 500);
      final body = Map<String, dynamic>.from(allCardsFixture);
      body['metadata'] = {
        'formatVersion': '2.0.0',
        'generatedOn': generatedOn,
        'language': 'de',
      };
      return http.Response.bytes(utf8.encode(jsonEncode(body)), 200);
    }
    return http.Response('not found', 404);
  });
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  SyncService service(http.Client client, {DateTime Function()? clock}) =>
      SyncService(db, LorcanaApi(client), clock: clock);

  test('empty DB triggers full sync', () async {
    final result = await service(_client()).syncIfNeeded();
    expect(result, SyncResult.synced);
    expect(await db.cardsDao.count(), 3);
    expect(await db.getSetting(SettingKeys.lastGeneratedOn('de')),
        _generatedOn);
  });

  test('cards stored with searchName, ink, cardmarketId', () async {
    await service(_client()).syncIfNeeded();
    final card = await db.cardsDao.byId(2);
    expect(card, isNotNull);
    expect(card!.searchName, 'maechtiger zauberer');
    expect(card.ink, 'Amethyst');
    expect(jsonDecode(card.inksJson), ['Amethyst', 'Steel']);
    expect(card.cardmarketId, 102);
    final promo = await db.cardsDao.byId(3);
    expect(promo!.cardmarketId, isNull);
    expect(promo.promoGrouping, 'D23');
  });

  test('recent check is skipped without any network call', () async {
    await service(_client()).syncIfNeeded();
    var calls = 0;
    final result =
        await service(_client(onRequest: (_) => calls++)).syncIfNeeded();
    expect(result, SyncResult.skipped);
    expect(calls, 0);
  });

  test('stale check + same generatedOn = upToDate, no card download',
      () async {
    await service(_client()).syncIfNeeded();
    final later = DateTime.now().add(const Duration(hours: 25));
    final paths = <String>[];
    final result = await service(
      _client(onRequest: paths.add),
      clock: () => later,
    ).syncIfNeeded();
    expect(result, SyncResult.upToDate);
    expect(paths.where((p) => p.endsWith('allCards.json')), isEmpty);
  });

  test('stale check + new generatedOn = full re-sync', () async {
    await service(_client()).syncIfNeeded();
    final later = DateTime.now().add(const Duration(hours: 25));
    final result = await service(
      _client(generatedOn: '2026-07-10T00:00:00Z'),
      clock: () => later,
    ).syncIfNeeded();
    expect(result, SyncResult.synced);
    expect(await db.getSetting(SettingKeys.lastGeneratedOn('de')),
        '2026-07-10T00:00:00Z');
  });

  test('metadata 404 falls back to allCards embedded metadata',
      () async {
    await service(_client()).syncIfNeeded();
    final later = DateTime.now().add(const Duration(hours: 25));
    // Same generatedOn embedded — must detect upToDate via fallback.
    final result = await service(
      _client(metadataFails: true),
      clock: () => later,
    ).syncIfNeeded();
    expect(result, SyncResult.upToDate);
  });

  test('network failure with cached cards = failedWithCache', () async {
    await service(_client()).syncIfNeeded();
    final later = DateTime.now().add(const Duration(hours: 25));
    final result = await service(
      _client(metadataFails: true, allCardsFails: true),
      clock: () => later,
    ).syncIfNeeded();
    expect(result, SyncResult.failedWithCache);
    expect(await db.cardsDao.count(), 3);
  });

  test('network failure with empty DB = failedNoData', () async {
    final result = await service(_client(allCardsFails: true)).syncIfNeeded();
    expect(result, SyncResult.failedNoData);
  });

  test('force re-syncs regardless of throttle', () async {
    await service(_client()).syncIfNeeded();
    final result = await service(_client(generatedOn: 'new'))
        .syncIfNeeded(force: true);
    expect(result, SyncResult.synced);
  });
}

