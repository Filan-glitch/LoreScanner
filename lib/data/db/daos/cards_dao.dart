import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardsDao extends DatabaseAccessor<AppDatabase> with _$CardsDaoMixin {
  CardsDao(super.db);

  Future<int> count() async {
    final expr = cards.id.count();
    final query = selectOnly(cards)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Replaces all cards of [language] with [entries] in one transaction —
  /// batch insert, no per-row connection churn.
  Future<void> replaceLanguage(
    String language,
    List<CardsCompanion> entries,
  ) async {
    await transaction(() async {
      await (delete(cards)..where((c) => c.language.equals(language))).go();
      await batch((b) => b.insertAll(cards, entries));
    });
  }

  Future<Card?> byId(int id) =>
      (select(cards)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<Card?> bySetAndNumber(String setCode, int number) => (select(cards)
        ..where((c) => c.setCode.equals(setCode) & c.number.equals(number)))
      .getSingleOrNull();

  Stream<List<Card>> watchAll() => select(cards).watch();
}
