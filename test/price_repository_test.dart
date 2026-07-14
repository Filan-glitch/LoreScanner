import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lorescanner/data/api/cardmarket_api.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/card_repository.dart';
import 'package:lorescanner/data/repositories/price_repository.dart';
import 'package:lorescanner/domain/models/collection_value.dart';

http.Response _guide(List<int> productIds) => http.Response.bytes(
      utf8.encode(jsonEncode({
        'priceGuides': [
          for (final id in productIds)
            {'idProduct': id, 'avg': 1.5, 'avg-foil': 3.0, 'trend': 1.2},
        ],
      })),
      200,
    );

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  Future<void> seedCards(List<int> cardmarketIds) async {
    var id = 1;
    await db.cardsDao.replaceLanguage('de', [
      for (final cmId in cardmarketIds)
        CardsCompanion.insert(
          id: id,
          setCode: '1',
          number: id++,
          simpleName: 'c',
          fullName: 'c',
          searchName: 'c',
          rarity: 'common',
          type: 'character',
          story: '',
          cost: 1,
          inkwell: false,
          cardmarketId: Value(cmId),
        ),
    ]);
  }

  PriceRepository repo(MockClient client, {DateTime Function()? clock}) =>
      PriceRepository(db, CardmarketApi(client), clock: clock);

  test('fetches and stores prices, sets lastPriceFetchAt', () async {
    final client = MockClient((r) async => _guide([101, 102]));
    await repo(client).refreshIfStale();
    expect(await db.pricesDao.count(), 2);
    expect((await db.pricesDao.byCardmarketId(101))!.avg, 1.5);
    expect(await db.getSettingDateTime(SettingKeys.lastPriceFetchAt),
        isNotNull);
  });

  test('fresh cache skips network', () async {
    await repo(MockClient((r) async => _guide([101]))).refreshIfStale();
    var calls = 0;
    await repo(MockClient((r) async {
      calls++;
      return _guide([999]);
    })).refreshIfStale();
    expect(calls, 0);
    expect(await db.pricesDao.byCardmarketId(101), isNotNull);
  });

  test('stale cache refetches', () async {
    await repo(MockClient((r) async => _guide([101]))).refreshIfStale();
    final later = DateTime.now().add(const Duration(hours: 25));
    await repo(
      MockClient((r) async => _guide([202])),
      clock: () => later,
    ).refreshIfStale();
    expect(await db.pricesDao.byCardmarketId(202), isNotNull);
    expect(await db.pricesDao.byCardmarketId(101), isNull);
  });

  test('404 triggers id rotation probe, accepts matching guide', () async {
    await seedCards([101, 102, 103]);
    await repo(MockClient((r) async {
      if (r.url.path.contains('price_guide_19')) {
        return http.Response('gone', 404);
      }
      if (r.url.path.contains('price_guide_20')) {
        // Wrong game: no overlap with known ids.
        return _guide([901, 902, 903]);
      }
      if (r.url.path.contains('price_guide_21')) {
        return _guide([101, 102, 999]);
      }
      return http.Response('gone', 404);
    })).refreshIfStale();

    expect(await db.getSetting(SettingKeys.priceGuideId), '21');
    expect(await db.pricesDao.count(), 3);
  });

  test('rotation probe failure keeps stale cache', () async {
    await seedCards([101]);
    await repo(MockClient((r) async => _guide([101]))).refreshIfStale();
    final later = DateTime.now().add(const Duration(hours: 25));
    await repo(
      MockClient((r) async => http.Response('gone', 404)),
      clock: () => later,
    ).refreshIfStale();
    // Old cache untouched, id unchanged.
    expect(await db.pricesDao.byCardmarketId(101), isNotNull);
    expect(await db.getSetting(SettingKeys.priceGuideId), isNull);
  });

  group('CollectionValue', () {
    Card card(int id, int? cmId) => Card(
          id: id,
          setCode: '1',
          number: id,
          language: 'de',
          simpleName: 'c',
          fullName: 'c',
          searchName: 'c',
          rarity: 'common',
          type: 'character',
          story: '',
          ink: 'Amber',
          inksJson: '["Amber"]',
          cost: 1,
          inkwell: false,
          promoGrouping: null,
          foilTypesJson: '[]',
          imagesJson: '{}',
          externalLinksJson: '{}',
          cardmarketId: cmId,
        );

    Price price(int cmId, {double? avg, double? avgFoil, double? trend}) =>
        Price(
          cardmarketId: cmId,
          avg: avg,
          low: null,
          trend: trend,
          avg1: null,
          avg7: null,
          avg30: null,
          avgFoil: avgFoil,
          lowFoil: null,
          trendFoil: null,
          avg1Foil: null,
          avg7Foil: null,
          avg30Foil: null,
          fetchedAt: 1000,
        );

    test('sums amount*avg + amountFoil*avgFoil with coverage', () {
      final value = CollectionValue.compute(
        [
          CollectionCard(card: card(1, 101), amount: 2, amountFoil: 1),
          CollectionCard(card: card(2, 102), amount: 1), // no price
          CollectionCard(card: card(3, null), amount: 1), // no cm id
          CollectionCard(card: card(4, 104)), // not owned
        ],
        {
          101: price(101, avg: 2.0, avgFoil: 5.0),
        },
      );
      expect(value.total, 2 * 2.0 + 1 * 5.0);
      expect(value.pricedCards, 1);
      expect(value.ownedCards, 3);
    });

    test('falls back to trend when avg missing', () {
      final value = CollectionValue.compute(
        [CollectionCard(card: card(1, 101), amount: 3)],
        {101: price(101, trend: 1.0)},
      );
      expect(value.total, 3.0);
    });
  });
}
