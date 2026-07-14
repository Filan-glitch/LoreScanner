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
  Set<String> failLanguages = const {},
  void Function(String path)? onRequest,
}) {
  return MockClient((request) async {
    onRequest?.call(request.url.path);
    if (failLanguages.any((l) => request.url.path.contains('/$l/'))) {
      return http.Response('down', 500);
    }
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
    expect(await db.cardsDao.countLanguage('de'), 3);
    expect(await db.getSetting(SettingKeys.lastGeneratedOn('de')),
        _generatedOn);
  });

  test('cards stored with searchName, ink, cardmarketId', () async {
    await service(_client()).syncIfNeeded();
    final card = await db.cardsDao.byIdAndLanguage(2, 'de');
    expect(card, isNotNull);
    expect(card!.searchName, 'maechtiger zauberer');
    expect(card.ink, 'Amethyst');
    expect(jsonDecode(card.inksJson), ['Amethyst', 'Steel']);
    expect(card.cardmarketId, 102);
    final promo = await db.cardsDao.byIdAndLanguage(3, 'de');
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
    expect(await db.cardsDao.countLanguage('de'), 3);
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

  test('partial failure: empty language is retried within the 24h window',
      () async {
    // de succeeds, en fails — the shared throttle timestamp must not
    // starve the still-empty language on the next launch.
    final first =
        await service(_client(failLanguages: {'en'})).syncIfNeeded();
    expect(first, SyncResult.failedWithCache);
    expect(await db.cardsDao.countLanguage('de'), 3);
    expect(await db.cardsDao.countLanguage('en'), 0);

    // Relaunch minutes later with the network healthy — en syncs now,
    // not after the throttle window expires.
    final second = await service(_client()).syncIfNeeded();
    expect(second, SyncResult.synced);
    expect(await db.cardsDao.countLanguage('en'), 3);
  });

  test('both languages sync side by side without PK conflict', () async {
    // lorcanajson ids are identical across languages — (id, language) PK
    // holds both permanently.
    await service(_client()).syncIfNeeded();
    expect(await db.cardsDao.countLanguage('de'), 3);
    expect(await db.cardsDao.countLanguage('en'), 3);
    expect((await db.cardsDao.byIdAndLanguage(1, 'de'))!.language, 'de');
    expect((await db.cardsDao.byIdAndLanguage(1, 'en'))!.language, 'en');
  });
}

