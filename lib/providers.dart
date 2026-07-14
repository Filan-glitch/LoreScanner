import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'data/api/cardmarket_api.dart';
import 'data/api/lorcana_api.dart';
import 'data/db/app_database.dart';
import 'data/repositories/card_repository.dart';
import 'data/repositories/price_repository.dart';
import 'data/repositories/sync_service.dart';
import 'domain/models/collection_filter.dart';
import 'domain/models/collection_stats.dart';
import 'domain/models/collection_value.dart';
import 'domain/scan/match_index.dart';
import 'domain/scan/scan_controller.dart';
import 'domain/scan/scan_state.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final lorcanaApiProvider =
    Provider<LorcanaApi>((ref) => LorcanaApi(ref.watch(httpClientProvider)));

final syncServiceProvider = Provider<SyncService>((ref) =>
    SyncService(ref.watch(databaseProvider), ref.watch(lorcanaApiProvider)));

/// One-shot startup gate: legacy import, then card sync. The splash screen
/// blocks on this; every failure mode except an empty DB lets the app
/// continue from cache.
final startupProvider = FutureProvider<SyncResult>((ref) async {
  final db = ref.watch(databaseProvider);
  await db.importLegacyCollectionIfNeeded();
  final result = await ref.watch(syncServiceProvider).syncIfNeeded();
  // Prices refresh in the background after sync — never blocks startup.
  unawaited(ref.read(priceRepositoryProvider).refreshIfStale());
  return result;
});

final cardmarketApiProvider = Provider<CardmarketApi>(
    (ref) => CardmarketApi(ref.watch(httpClientProvider)));

final priceRepositoryProvider = Provider<PriceRepository>((ref) =>
    PriceRepository(
        ref.watch(databaseProvider), ref.watch(cardmarketApiProvider)));

/// All cached prices keyed by cardmarket id.
final pricesMapProvider = StreamProvider<Map<int, Price>>((ref) => ref
    .watch(databaseProvider)
    .pricesDao
    .watchAll()
    .map((rows) => {for (final p in rows) p.cardmarketId: p}));

/// Total collection value + coverage, reactive to prices and collection.
final collectionValueProvider = Provider<AsyncValue<CollectionValue>>((ref) {
  final prices = ref.watch(pricesMapProvider);
  final cards = ref.watch(allCardsProvider);
  if (prices.hasValue && cards.hasValue) {
    return AsyncValue.data(
        CollectionValue.compute(cards.requireValue, prices.requireValue));
  }
  return const AsyncValue.loading();
});

final cardRepositoryProvider =
    Provider<CardRepository>((ref) => CardRepository(ref.watch(databaseProvider)));

/// Current card-data language ('de' default), reactive to settings writes.
final cardLanguageProvider = StreamProvider<String>((ref) => ref
    .watch(databaseProvider)
    .watchSetting(SettingKeys.cardLanguage)
    .map((v) => v ?? 'de'));

/// Full card list joined with collection amounts for the active language.
final allCardsProvider = StreamProvider<List<CollectionCard>>((ref) {
  final language = ref.watch(cardLanguageProvider).valueOrNull ?? 'de';
  return ref.watch(cardRepositoryProvider).watchAllWithCollection(language);
});

class CollectionFilterNotifier extends Notifier<CollectionFilter> {
  @override
  CollectionFilter build() => const CollectionFilter();

  void set(CollectionFilter filter) => state = filter;

  void reset() => state = const CollectionFilter();
}

final collectionFilterProvider =
    NotifierProvider<CollectionFilterNotifier, CollectionFilter>(
        CollectionFilterNotifier.new);

/// Card list with the active filter applied.
final filteredCardsProvider = Provider<AsyncValue<List<CollectionCard>>>((ref) {
  final filter = ref.watch(collectionFilterProvider);
  return ref
      .watch(allCardsProvider)
      .whenData((entries) => applyFilter(entries, filter));
});

final collectionStatsProvider = Provider<AsyncValue<CollectionStats>>((ref) =>
    ref.watch(allCardsProvider).whenData(CollectionStats.fromEntries));

/// Prebuilt scanner match index — rebuilds when the card list changes.
final matchIndexProvider = Provider<MatchIndex>((ref) {
  final entries = ref.watch(allCardsProvider).valueOrNull ?? const [];
  return MatchIndex.fromCards([for (final e in entries) e.card]);
});

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(
    () => ScanNotifier((ref) => ref.read(matchIndexProvider)));
