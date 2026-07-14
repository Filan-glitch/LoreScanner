import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'collection_dao.g.dart';

@DriftAccessor(tables: [CollectionEntries])
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(super.db);

  Stream<List<CollectionEntry>> watchAll() => select(collectionEntries).watch();

  Future<CollectionEntry?> byCard(int cardId, String language) =>
      (select(collectionEntries)
            ..where((e) =>
                e.cardId.equals(cardId) & e.language.equals(language)))
          .getSingleOrNull();

  /// Adds copies of a card in a specific language. Creates the row if
  /// absent.
  Future<void> addCard(
    int cardId,
    String language, {
    int amount = 1,
    int amountFoil = 0,
  }) async {
    await transaction(() async {
      final existing = await byCard(cardId, language);
      final now = DateTime.now().millisecondsSinceEpoch;
      if (existing == null) {
        await into(collectionEntries).insert(CollectionEntriesCompanion.insert(
          cardId: cardId,
          language: Value(language),
          amount: Value(amount),
          amountFoil: Value(amountFoil),
          updatedAt: now,
        ));
      } else {
        await update(collectionEntries).replace(existing.copyWith(
          amount: existing.amount + amount,
          amountFoil: existing.amountFoil + amountFoil,
          updatedAt: now,
        ));
      }
    });
  }

  /// Removes copies; deletes the row when both amounts reach zero.
  Future<void> removeCard(
    int cardId,
    String language, {
    int amount = 1,
    int amountFoil = 0,
  }) async {
    await transaction(() async {
      final existing = await byCard(cardId, language);
      if (existing == null) return;
      final newAmount = (existing.amount - amount).clamp(0, 1 << 31);
      final newFoil = (existing.amountFoil - amountFoil).clamp(0, 1 << 31);
      if (newAmount <= 0 && newFoil <= 0) {
        await (delete(collectionEntries)
              ..where((e) =>
                  e.cardId.equals(cardId) & e.language.equals(language)))
            .go();
      } else {
        await update(collectionEntries).replace(existing.copyWith(
          amount: newAmount,
          amountFoil: newFoil,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    });
  }

  /// Bulk import from the legacy sqflite DB — tagged with the language the
  /// v1 app was set to. Ignores conflicts so a re-run never clobbers newer
  /// data.
  Future<void> importLegacyRows(
    List<({int cardId, int amount, int amountFoil})> rows, {
    String language = 'de',
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await batch((b) {
      b.insertAll(
        collectionEntries,
        rows.map((r) => CollectionEntriesCompanion.insert(
              cardId: r.cardId,
              language: Value(language),
              amount: Value(r.amount),
              amountFoil: Value(r.amountFoil),
              updatedAt: now,
            )),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }
}
