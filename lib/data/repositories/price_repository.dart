import 'package:drift/drift.dart';

import '../../core/constants.dart';
import '../../core/logging.dart';
import '../api/cardmarket_api.dart';
import '../api/dtos.dart';
import '../db/app_database.dart';

/// Cache-first Cardmarket prices. Never blocks startup and never throws —
/// UI reads only the `prices` table; refresh is fire-and-forget.
class PriceRepository {
  PriceRepository(this._db, this._api, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final CardmarketApi _api;
  final DateTime Function() _clock;

  /// How many ids above the current one to probe when the catalog id
  /// rotates.
  static const _probeRange = 5;

  /// Minimum fraction of price rows that must join against known
  /// cardmarket ids for a probed guide to be accepted as the Lorcana one.
  static const _joinSanityThreshold = 0.5;

  Future<void> refreshIfStale({bool force = false}) async {
    try {
      final last =
          await _db.getSettingDateTime(SettingKeys.lastPriceFetchAt);
      final now = _clock();
      if (!force &&
          last != null &&
          now.difference(last) < priceRefreshInterval) {
        return;
      }

      final guideId = int.tryParse(
              await _db.getSetting(SettingKeys.priceGuideId) ?? '') ??
          defaultPriceGuideId;

      List<PriceDto>? dtos;
      try {
        dtos = await _api.fetchPriceGuide(guideId);
      } on CardmarketApiException catch (e) {
        if (!e.looksLikeRotatedId) rethrow;
        log.warning('Price guide $guideId gone ($e), probing for rotation');
        final rotated = await _probeRotatedId(guideId);
        if (rotated == null) {
          log.warning('No rotated price guide found - keeping stale cache');
          return;
        }
        dtos = rotated.dtos;
        await _db.setSetting(SettingKeys.priceGuideId, '${rotated.id}');
        log.info('Price guide id rotated: $guideId -> ${rotated.id}');
      }

      await _store(dtos, now);
      log.info('Stored ${dtos.length} prices (guide id $guideId)');
    } catch (e, st) {
      log.warning('Price refresh failed - keeping cache', e, st);
    }
  }

  Future<void> _store(List<PriceDto> dtos, DateTime now) async {
    final fetchedAt = now.millisecondsSinceEpoch;
    await _db.pricesDao.replaceAll([
      for (final dto in dtos)
        PricesCompanion.insert(
          cardmarketId: Value(dto.idProduct),
          avg: Value(dto.avg),
          low: Value(dto.low),
          trend: Value(dto.trend),
          avg1: Value(dto.avg1),
          avg7: Value(dto.avg7),
          avg30: Value(dto.avg30),
          avgFoil: Value(dto.avgFoil),
          lowFoil: Value(dto.lowFoil),
          trendFoil: Value(dto.trendFoil),
          avg1Foil: Value(dto.avg1Foil),
          avg7Foil: Value(dto.avg7Foil),
          avg30Foil: Value(dto.avg30Foil),
          fetchedAt: fetchedAt,
        ),
    ]);
    await _db.setSettingDateTime(SettingKeys.lastPriceFetchAt, now);
  }

  /// Probes ids above [staleId]; a candidate wins when >50% of the known
  /// card cardmarket ids appear in its product list (guards against
  /// grabbing another game's guide).
  Future<({int id, List<PriceDto> dtos})?> _probeRotatedId(int staleId) async {
    final knownIds = await _knownCardmarketIds();
    if (knownIds.isEmpty) return null;
    for (var id = staleId + 1; id <= staleId + _probeRange; id++) {
      try {
        final dtos = await _api.fetchPriceGuide(id);
        if (dtos.isEmpty) continue;
        final products = {for (final dto in dtos) dto.idProduct};
        final hits = knownIds.where(products.contains).length;
        if (hits / knownIds.length >= _joinSanityThreshold) {
          return (id: id, dtos: dtos);
        }
        log.info('Probe id $id join rate ${hits / knownIds.length} - reject');
      } on CardmarketApiException {
        continue;
      }
    }
    return null;
  }

  Future<Set<int>> _knownCardmarketIds() async {
    final expr = _db.cards.cardmarketId;
    final query = _db.selectOnly(_db.cards, distinct: true)
      ..addColumns([expr])
      ..where(expr.isNotNull());
    final rows = await query.get();
    return {for (final row in rows) row.read(expr)!};
  }
}
