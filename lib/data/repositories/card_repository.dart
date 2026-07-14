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
}

class CardRepository {
  CardRepository(this._db);

  final AppDatabase _db;

  /// All cards of [language] left-joined with collection amounts, ordered
  /// by set and collector number. Reactive to card sync and collection
  /// changes.
  Stream<List<CollectionCard>> watchAllWithCollection(String language) {
    final query = _db.select(_db.cards).join([
      leftOuterJoin(
        _db.collectionEntries,
        _db.collectionEntries.cardId.equalsExp(_db.cards.id),
      ),
    ])
      ..where(_db.cards.language.equals(language));

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
      // with the canonical numeric-then-Q comparator.
      entries.sort((a, b) {
        final sets = compareSetCodes(a.card.setCode, b.card.setCode);
        return sets != 0 ? sets : a.card.number.compareTo(b.card.number);
      });
      return entries;
    });
  }

  /// Distinct set codes of [language], numeric sets first then Q-sets.
  Future<List<String>> setCodes(String language) async {
    final expr = _db.cards.setCode;
    final query = _db.selectOnly(_db.cards, distinct: true)
      ..addColumns([expr])
      ..where(_db.cards.language.equals(language));
    final rows = await query.get();
    return [for (final row in rows) row.read(expr)!]..sort(compareSetCodes);
  }

  /// Distinct rarities of [language] in canonical rarity order.
  Future<List<String>> rarities(String language) async {
    final expr = _db.cards.rarity;
    final query = _db.selectOnly(_db.cards, distinct: true)
      ..addColumns([expr])
      ..where(_db.cards.language.equals(language));
    final rows = await query.get();
    return [for (final row in rows) row.read(expr)!]..sort(compareRarities);
  }
}
