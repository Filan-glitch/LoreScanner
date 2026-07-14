import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'prices_dao.g.dart';

@DriftAccessor(tables: [Prices])
class PricesDao extends DatabaseAccessor<AppDatabase> with _$PricesDaoMixin {
  PricesDao(super.db);

  Future<Price?> byCardmarketId(int id) =>
      (select(prices)..where((p) => p.cardmarketId.equals(id)))
          .getSingleOrNull();

  Stream<Price?> watchByCardmarketId(int id) =>
      (select(prices)..where((p) => p.cardmarketId.equals(id)))
          .watchSingleOrNull();

  Stream<List<Price>> watchAll() => select(prices).watch();

  /// Replaces the full price cache in one transaction.
  Future<void> replaceAll(List<PricesCompanion> entries) async {
    await transaction(() async {
      await delete(prices).go();
      await batch((b) => b.insertAll(prices, entries));
    });
  }

  Future<int> count() async {
    final expr = prices.cardmarketId.count();
    final query = selectOnly(prices)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }
}
