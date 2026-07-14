import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/card_repository.dart';
import 'package:lorescanner/domain/models/collection_filter.dart';
import 'package:lorescanner/domain/models/collection_stats.dart';

Card _card({
  required int id,
  String setCode = '1',
  String rarity = 'Gewöhnlich',
  String inksJson = '["Bernstein"]',
  String language = 'de',
}) {
  return Card(
    id: id,
    setCode: setCode,
    number: id,
    language: language,
    simpleName: 'Card $id',
    fullName: 'Card $id',
    searchName: 'card $id',
    rarity: rarity,
    type: 'character',
    story: '',
    ink: 'Bernstein',
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
    CollectionCard(card: _card(id: 2, setCode: '2', rarity: 'Selten')),
    CollectionCard(
      card: _card(id: 3, setCode: '5', inksJson: '["Amethyst","Stahl"]'),
      amountFoil: 1,
    ),
    CollectionCard(card: _card(id: 4, rarity: 'Legendär')),
    // English print of card 1 — separate entry with its own amounts.
    CollectionCard(
      card: _card(id: 1, language: 'en', rarity: 'Common', inksJson: '["Amber"]'),
      amount: 1,
    ),
  ];

  group('CollectionFilter', () {
    test('default filter shows owned only', () {
      final result = applyFilter(entries, const CollectionFilter());
      expect(result.map((e) => e.card.id), [1, 3, 1]);
    });

    test('ownedOnly false shows everything', () {
      final result =
          applyFilter(entries, const CollectionFilter(ownedOnly: false));
      expect(result, hasLength(5));
    });

    test('language filter separates DE and EN prints', () {
      final de = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, languages: {'de'}),
      );
      expect(de.every((e) => e.card.language == 'de'), isTrue);
      final en = applyFilter(
        entries,
        const CollectionFilter(languages: {'en'}),
      );
      expect(en.single.card.language, 'en');
      expect(en.single.amount, 1);
    });

    test('set filter', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, sets: {'2'}),
      );
      expect(result.single.card.id, 2);
    });

    test('rarity filter matches German chip against both languages', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, rarities: {'Legendär'}),
      );
      expect(result.single.card.id, 4);
      // German chip 'Gewöhnlich' also matches the EN print ('Common').
      final commons = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, rarities: {'Gewöhnlich'}),
      );
      expect(commons.map((e) => e.card.language), contains('en'));
    });

    test('dual-ink card matches under each of its inks', () {
      for (final ink in ['Amethyst', 'Stahl']) {
        final result = applyFilter(
          entries,
          CollectionFilter(ownedOnly: false, inks: {ink}),
        );
        expect(result.map((e) => e.card.id), contains(3),
            reason: 'expected card 3 under $ink');
      }
      final amber = applyFilter(
        entries,
        const CollectionFilter(ownedOnly: false, inks: {'Bernstein'}),
      );
      expect(amber.map((e) => e.card.id), isNot(contains(3)));
      // German ink chip matches the EN print's English ink name.
      expect(amber.map((e) => e.card.language), contains('en'));
    });

    test('combined filters AND together', () {
      final result = applyFilter(
        entries,
        const CollectionFilter(sets: {'1'}, rarities: {'Gewöhnlich'}),
      );
      // DE and EN print of card 1 both match.
      expect(result.map((e) => e.card.id), [1, 1]);
    });
  });

  group('CollectionStats', () {
    test('computes owned, copies, rarity and set completion', () {
      final stats = CollectionStats.fromEntries(entries);
      // DE + EN print of card 1 count as separate owned entries…
      expect(stats.ownedUnique, 3);
      expect(stats.totalCopies, 4);
      expect(stats.rarityCounts, {'Gewöhnlich': 2, 'Common': 1});
      // …but set completion is language-agnostic (distinct ids).
      expect(stats.setCompletion['1'], (owned: 1, total: 2));
      expect(stats.setCompletion['5'], (owned: 1, total: 1));
      expect(stats.setCompletion['2'], (owned: 0, total: 1));
    });
  });
}
