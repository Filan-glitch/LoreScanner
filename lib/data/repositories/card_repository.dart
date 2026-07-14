import 'package:drift/drift.dart';

import '../../core/card_order.dart';
import '../db/app_database.dart';

/// A card joined with its (possibly absent) collection entry.
class CollectionCard {
  const CollectionCard({
    required this.card,
    this.amount = 0,
    this.amountFoil = 0,
  });

  final Card card;
  final int amount;
  final int amountFoil;

  bool get isOwned => amount > 0 || amountFoil > 0;
  int get totalCopies => amount + amountFoil;

  // Value equality lets providers skip notifying dependents when an entry
  // is unchanged (drift's Card already implements ==).
  @override
  bool operator ==(Object other) =>
      other is CollectionCard &&
      other.card == card &&
      other.amount == amount &&
      other.amountFoil == amountFoil;

  @override
  int get hashCode => Object.hash(card, amount, amountFoil);
}

class CardRepository {
  CardRepository(this._db);

  final AppDatabase _db;

  /// All cards (both languages) left-joined with collection amounts,
  /// ordered by set and collector number. German and English prints are
  /// separate rows — the collection join matches on (id, language).
  Stream<List<CollectionCard>> watchAllWithCollection() {
    final query = _db.select(_db.cards).join([
      leftOuterJoin(
        _db.collectionEntries,
        _db.collectionEntries.cardId.equalsExp(_db.cards.id) &
            _db.collectionEntries.language.equalsExp(_db.cards.language),
      ),
    ]);

    return query.watch().map((rows) {
      final entries = [
        for (final row in rows)
          CollectionCard(
            card: row.readTable(_db.cards),
            amount: row.readTableOrNull(_db.collectionEntries)?.amount ?? 0,
            amountFoil:
                row.readTableOrNull(_db.collectionEntries)?.amountFoil ?? 0,
          ),
      ];
      // set_code is TEXT — SQL ordering yields 1,10,11,2,… Sort in Dart
      // with the canonical numeric-then-Q comparator; same-card language
      // variants sit next to each other (de before en).
      entries.sort((a, b) {
        final sets = compareSetCodes(a.card.setCode, b.card.setCode);
        if (sets != 0) return sets;
        final numbers = a.card.number.compareTo(b.card.number);
        if (numbers != 0) return numbers;
        return a.card.language.compareTo(b.card.language);
      });
      return entries;
    });
  }

  /// Adds copies of a card to the collection. Creates the row if absent.
  Future<void> addCard(
    int cardId,
    String language, {
    int amount = 1,
    int amountFoil = 0,
  }) =>
      _db.collectionDao
          .addCard(cardId, language, amount: amount, amountFoil: amountFoil);

  /// Removes copies; the row is deleted when both amounts reach zero.
  Future<void> removeCard(
    int cardId,
    String language, {
    int amount = 1,
    int amountFoil = 0,
  }) =>
      _db.collectionDao.removeCard(cardId, language,
          amount: amount, amountFoil: amountFoil);

  /// Distinct set codes, numeric sets first then Q-sets.
  Future<List<String>> setCodes() async {
    final expr = _db.cards.setCode;
    final query = _db.selectOnly(_db.cards, distinct: true)
      ..addColumns([expr]);
    final rows = await query.get();
    return [for (final row in rows) row.read(expr)!]..sort(compareSetCodes);
  }

  /// Distinct rarities in canonical rarity order. German rarity names only
  /// (the UI is German); the language filter separates the card languages.
  Future<List<String>> rarities() async {
    final expr = _db.cards.rarity;
    final query = _db.selectOnly(_db.cards, distinct: true)
      ..addColumns([expr])
      ..where(_db.cards.language.equals('de'));
    final rows = await query.get();
    return [for (final row in rows) row.read(expr)!]..sort(compareRarities);
  }
}
