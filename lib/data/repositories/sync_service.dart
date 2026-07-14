import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/constants.dart';
import '../../core/logging.dart';
import '../../core/normalize.dart';
import '../api/dtos.dart';
import '../api/lorcana_api.dart';
import '../db/app_database.dart';

/// Outcome of a sync attempt.
enum SyncResult {
  /// Cards downloaded and stored.
  synced,

  /// Remote data unchanged — nothing downloaded.
  upToDate,

  /// Check throttled (last check < [cardSyncCheckInterval] ago).
  skipped,

  /// Network/parse failure but the app has cards — safe to continue.
  failedWithCache,

  /// Failure and the DB is empty — the app cannot run.
  failedNoData,
}

/// Keeps the card list current against lorcanajson.
///
/// Decision matrix (per launch):
/// - cards table empty → full sync (caller should block on this)
/// - `force` (language switch, manual refresh) → full sync
/// - last check < 24h ago → skip
/// - else compare `metadata.generatedOn` → full sync only when changed
class SyncService {
  SyncService(this._db, this._api, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final LorcanaApi _api;
  final DateTime Function() _clock;

  Future<String> get _language async =>
      await _db.getSetting(SettingKeys.cardLanguage) ?? 'de';

  Future<SyncResult> syncIfNeeded({bool force = false}) async {
    final language = await _language;
    final hasCards = await _db.cardsDao.count() > 0;

    if (!hasCards || force) {
      return _fullSync(language, hasCards: hasCards);
    }

    final lastCheck =
        await _db.getSettingDateTime(SettingKeys.lastSyncCheckAt);
    final now = _clock();
    if (lastCheck != null && now.difference(lastCheck) < cardSyncCheckInterval) {
      return SyncResult.skipped;
    }

    final stored =
        await _db.getSetting(SettingKeys.lastGeneratedOn(language));
    try {
      final metadata = await _api.fetchMetadata(language);
      if (metadata.generatedOn == stored) {
        await _db.setSettingDateTime(SettingKeys.lastSyncCheckAt, now);
        return SyncResult.upToDate;
      }
      return _fullSync(language, hasCards: true);
    } on LorcanaApiException catch (e) {
      // metadata.json gone? Fall back to comparing allCards' embedded
      // metadata before writing anything.
      log.warning('metadata.json probe failed, falling back to allCards: $e');
      return _fullSync(language, hasCards: true, skipIfGeneratedOn: stored);
    } catch (e, st) {
      log.warning('Sync check failed', e, st);
      return SyncResult.failedWithCache;
    }
  }

  Future<SyncResult> _fullSync(
    String language, {
    required bool hasCards,
    String? skipIfGeneratedOn,
  }) async {
    try {
      final result = await _api.fetchAllCards(language);
      if (skipIfGeneratedOn != null &&
          result.metadata.generatedOn == skipIfGeneratedOn) {
        await _db.setSettingDateTime(SettingKeys.lastSyncCheckAt, _clock());
        return SyncResult.upToDate;
      }
      final companions =
          [for (final dto in result.cards) _toCompanion(dto, language)];
      await _db.cardsDao.replaceLanguage(language, companions);
      await _db.setSetting(
          SettingKeys.lastGeneratedOn(language), result.metadata.generatedOn);
      await _db.setSettingDateTime(SettingKeys.lastSyncCheckAt, _clock());
      log.info('Synced ${companions.length} cards ($language, '
          'generatedOn ${result.metadata.generatedOn})');
      return SyncResult.synced;
    } catch (e, st) {
      log.severe('Card sync failed', e, st);
      return hasCards ? SyncResult.failedWithCache : SyncResult.failedNoData;
    }
  }

  static CardsCompanion _toCompanion(CardDto dto, String language) {
    return CardsCompanion.insert(
      id: Value(dto.id),
      setCode: dto.setCode,
      number: dto.number,
      language: Value(language),
      simpleName: dto.simpleName,
      fullName: dto.fullName,
      searchName: normalizeName(dto.simpleName),
      rarity: dto.rarity,
      type: dto.type,
      story: dto.story,
      ink: Value(dto.primaryInk),
      inksJson: Value(jsonEncode(dto.inks)),
      cost: dto.cost,
      inkwell: dto.inkwell,
      promoGrouping: Value(dto.promoGrouping),
      foilTypesJson: Value(jsonEncode(dto.foilTypes)),
      imagesJson: Value(jsonEncode(dto.images)),
      externalLinksJson: Value(jsonEncode(dto.externalLinks)),
      cardmarketId: Value(dto.cardmarketId),
    );
  }
}
