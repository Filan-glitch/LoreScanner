import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/card_repository.dart';
import 'package:lorescanner/domain/models/collection_filter.dart';
import 'package:lorescanner/domain/models/collection_stats.dart';

Card _card({
  required int id,
  String setCode = '1',
  String rarity = 'common',
  String inksJson = '["Amber"]',
}) {
  return Card(
    id: id,
    setCode: setCode,
    number: id,
    language: 'de',
    simpleName: 'Card $id',
    fullName: 'Card $id',
    searchName: 'card $id',
    rarity: rarity,
    type: 'character',
    story: '',
    ink: 'Amber',
    inksJson: inksJson,
    cost: 1,
    inkwell: false,
    promoGrouping: null,
    foilTypesJson: '[]',
    imagesJson: '{}',
    externalLinksJson: '{}',
    cardmarketId: null,
  );
}

void main() {
  final entries = [
    CollectionCard(card: _card(id: 1), amount: 2),
    CollectionCard(card: _card(id: 2, setCode: '2', rarity: 'rare')),
    CollectionCard(
      card: _card(id: 3, setCode: '5', inksJson: '["Amethyst","Steel"]'),
      amountFoil: 1,
    ),
    CollectionCard(card: _card(id: 4, rarity: 'legendary')),
  ];

  group('CollectionFilter', () {
    test('default filter shows owned only', () {
      final result = applyFilter(entries, const CollectionFilter());
      expect(result.map((e) => e.card.id), [1, 3]);
    });

    test('ownedOnly false shows everything', () {
      final result =
          applyFilter(entries, const CollectionFilter(ownedOnly: false));
      expect(result, hasLength(4));
    });

    test('set filter', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, sets: {'2'}),
      );
      expect(result.single.card.id, 2);
    });

    test('rarity filter', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, rarities: {'legendary'}),
      );
      expect(result.single.card.id, 4);
    });

    test('dual-ink card matches under each of its inks', () {
      for (final ink in ['Amethyst', 'Steel']) {
        final result = applyFilter(
          entries,
          CollectionFilter(ownedOnly: false, inks: {ink}),
        );
        expect(result.map((e) => e.card.id), contains(3),
            reason: 'expected card 3 under $ink');
      }
      final amber = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, inks: {'Amber'}),
      );
      expect(amber.map((e) => e.card.id), isNot(contains(3)));
    });

    test('combined filters AND together', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(sets: {'1'}, rarities: {'common'}),
      );
      expect(result.single.card.id, 1);
    });
  });

  group('CollectionStats', () {
    test('computes owned, copies, rarity and set completion', () {
      final stats = CollectionStats.fromEntries(entries);
      expect(stats.ownedUnique, 2);
      expect(stats.totalCopies, 3);
      expect(stats.rarityCounts, {'common': 2});
      expect(stats.setCompletion['1'], (owned: 1, total: 2));
      expect(stats.setCompletion['5'], (owned: 1, total: 1));
      expect(stats.setCompletion['2'], (owned: 0, total: 1));
    });
  });
}
