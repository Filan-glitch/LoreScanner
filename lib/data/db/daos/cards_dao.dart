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

  Future<int> countLanguage(String language) async {
    final expr = cards.id.count();
    final query = selectOnly(cards)
      ..addColumns([expr])
      ..where(cards.language.equals(language));
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }

  /// Replaces all cards of one [language] in one transaction. Both
  /// languages live in the table permanently — (id, language) is the PK.
  Future<void> replaceLanguage(
    String language,
    List<CardsCompanion> entries,
  ) async {
    await transaction(() async {
      await (delete(cards)..where((c) => c.language.equals(language))).go();
      await batch((b) => b.insertAll(cards, entries));
    });
  }

  Future<Card?> byIdAndLanguage(int id, String language) => (select(cards)
        ..where((c) => c.id.equals(id) & c.language.equals(language)))
      .getSingleOrNull();

  Stream<List<Card>> watchAll() => select(cards).watch();
}
