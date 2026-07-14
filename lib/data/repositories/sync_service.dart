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
  /// At least one language downloaded and stored.
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

/// Keeps the card list current against lorcanajson — both supported
/// languages permanently.
///
/// Decision matrix (per launch, per language):
/// - language has no cards → full sync (caller should block on this)
/// - `force` (manual refresh) → full sync
/// - last check < 24h ago → skip
/// - else compare `metadata.generatedOn` → full sync only when changed
class SyncService {
  SyncService(this._db, this._api, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final LorcanaApi _api;
  final DateTime Function() _clock;

  Future<SyncResult> syncIfNeeded({bool force = false}) async {
    // The throttle only applies once every supported language has cards —
    // a language left empty by a partial failure must be retried on the
    // next launch, not masked by the other language's success.
    var allLanguagesHaveCards = true;
    for (final language in supportedLanguages) {
      if (await _db.cardsDao.countLanguage(language) == 0) {
        allLanguagesHaveCards = false;
        break;
      }
    }

    if (!force && allLanguagesHaveCards) {
      final lastCheck =
          await _db.getSettingDateTime(SettingKeys.lastSyncCheckAt);
      final now = _clock();
      if (lastCheck != null &&
          now.difference(lastCheck) < cardSyncCheckInterval) {
        return SyncResult.skipped;
      }
    }

    var anySynced = false;
    var anyFailed = false;
    for (final language in supportedLanguages) {
      final result = await _syncLanguage(language, force: force);
      anySynced |= result == _LanguageResult.synced;
      anyFailed |= result == _LanguageResult.failed;
    }

    if (!anyFailed || anySynced) {
      await _db.setSettingDateTime(SettingKeys.lastSyncCheckAt, _clock());
    }
    if (anyFailed) {
      return await _db.cardsDao.count() > 0
          ? SyncResult.failedWithCache
          : SyncResult.failedNoData;
    }
    return anySynced ? SyncResult.synced : SyncResult.upToDate;
  }

  Future<_LanguageResult> _syncLanguage(
    String language, {
    required bool force,
  }) async {
    final hasCards = await _db.cardsDao.countLanguage(language) > 0;
    final stored =
        await _db.getSetting(SettingKeys.lastGeneratedOn(language));

    if (hasCards && !force) {
      try {
        final metadata = await _api.fetchMetadata(language);
        if (metadata.generatedOn == stored) return _LanguageResult.upToDate;
      } on LorcanaApiException catch (e) {
        // metadata.json gone? Fall through to allCards with an embedded
        // metadata comparison.
        log.warning('metadata.json probe failed for $language: $e');
        return _fullSync(language, skipIfGeneratedOn: stored);
      } catch (e, st) {
        log.warning('Sync check failed for $language', e, st);
        return _LanguageResult.failed;
      }
    }

    return _fullSync(language);
  }

  Future<_LanguageResult> _fullSync(
    String language, {
    String? skipIfGeneratedOn,
  }) async {
    try {
      final result = await _api.fetchAllCards(language);
      if (skipIfGeneratedOn != null &&
          result.metadata.generatedOn == skipIfGeneratedOn) {
        return _LanguageResult.upToDate;
      }
      final companions =
          [for (final dto in result.cards) _toCompanion(dto, language)];
      await _db.cardsDao.replaceLanguage(language, companions);
      await _db.setSetting(
          SettingKeys.lastGeneratedOn(language), result.metadata.generatedOn);
      log.info('Synced ${companions.length} cards ($language, '
          'generatedOn ${result.metadata.generatedOn})');
      return _LanguageResult.synced;
    } catch (e, st) {
      log.severe('Card sync failed for $language', e, st);
      return _LanguageResult.failed;
    }
  }

  static CardsCompanion _toCompanion(CardDto dto, String language) {
    return CardsCompanion.insert(
      id: dto.id,
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

enum _LanguageResult { synced, upToDate, failed }
