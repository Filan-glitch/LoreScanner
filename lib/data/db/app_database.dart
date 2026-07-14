import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import '../../core/logging.dart';
import 'daos/cards_dao.dart';
import 'daos/collection_dao.dart';
import 'daos/prices_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Well-known settings keys.
abstract final class SettingKeys {
  static const cardLanguage = 'cardLanguage';
  static const lastSyncCheckAt = 'lastSyncCheckAt';
  static const lastPriceFetchAt = 'lastPriceFetchAt';
  static const priceGuideId = 'priceGuideId';
  static const legacyImportDone = 'legacyImportDone';
  static const themeMode = 'themeMode';

  static String lastGeneratedOn(String language) =>
      'lastGeneratedOn.$language';
}

@DriftDatabase(
  tables: [Cards, CollectionEntries, Prices, Settings],
  daos: [CardsDao, CollectionDao, PricesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'lorcana_v2'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_cards_set ON cards (set_code)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_cards_lookup ON cards (set_code, number)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_cards_cm ON cards (cardmarket_id)');
        },
      );

  // --- Settings helpers ---

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Stream<String?> watchSetting(String key) =>
      (select(settings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<DateTime?> getSettingDateTime(String key) async {
    final raw = await getSetting(key);
    final ms = raw == null ? null : int.tryParse(raw);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setSettingDateTime(String key, DateTime value) =>
      setSetting(key, value.millisecondsSinceEpoch.toString());

  // --- Legacy migration (old sqflite lorcana.db) ---

  /// Imports the `collection` table from the legacy sqflite database once.
  /// Non-fatal on any failure — worst case the user re-scans.
  Future<void> importLegacyCollectionIfNeeded() async {
    if (await getSetting(SettingKeys.legacyImportDone) != null) return;
    try {
      final legacyFile = await _locateLegacyDb();
      if (legacyFile == null) {
        log.info('No legacy lorcana.db found - skipping import');
      } else {
        final imported = importLegacyCollectionFrom(legacyFile.path);
        await collectionDao.importLegacyRows(imported);
        log.info('Imported ${imported.length} legacy collection rows');
        try {
          legacyFile.renameSync('${legacyFile.path}.bak');
        } on FileSystemException catch (e) {
          log.warning('Could not rename legacy DB: $e');
        }
      }
    } catch (e, st) {
      log.severe('Legacy collection import failed (non-fatal)', e, st);
    }
    await setSetting(SettingKeys.legacyImportDone, '1');
  }

  /// Reads collection rows from a legacy sqflite file. Static-ish and
  /// side-effect free so tests can call it against a fixture file.
  static List<({int cardId, int amount, int amountFoil})>
      importLegacyCollectionFrom(String path) {
    final db = sqlite3.sqlite3.open(path, mode: sqlite3.OpenMode.readOnly);
    try {
      final result =
          db.select('SELECT cardId, amount, amountFoil FROM collection');
      return [
        for (final row in result)
          (
            cardId: row['cardId'] as int,
            amount: (row['amount'] as int?) ?? 0,
            amountFoil: (row['amountFoil'] as int?) ?? 0,
          ),
      ];
    } finally {
      db.dispose();
    }
  }

  /// sqflite stores databases at `<app data>/databases` on Android and in
  /// the Documents directory on iOS.
  static Future<File?> _locateLegacyDb() async {
    final candidates = <String>[];
    try {
      final docs = await getApplicationDocumentsDirectory();
      // iOS: sqflite uses the Documents directory directly.
      candidates.add(p.join(docs.path, 'lorcana.db'));
      // Android: Documents is <data>/app_flutter; databases live in
      // <data>/databases.
      candidates.add(p.join(docs.parent.path, 'databases', 'lorcana.db'));
    } on MissingPluginException {
      return null;
    }
    for (final path in candidates) {
      final file = File(path);
      if (file.existsSync()) return file;
    }
    return null;
  }
}
