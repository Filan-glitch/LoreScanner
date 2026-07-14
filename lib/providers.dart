import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'data/api/lorcana_api.dart';
import 'data/db/app_database.dart';
import 'data/repositories/card_repository.dart';
import 'data/repositories/sync_service.dart';
import 'domain/models/collection_filter.dart';
import 'domain/models/collection_stats.dart';

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
  return ref.watch(syncServiceProvider).syncIfNeeded();
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
