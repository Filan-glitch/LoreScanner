import 'dart:async';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart' show ThemeMode;
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

/// Full card list (both languages) joined with per-language collection
/// amounts.
final allCardsProvider = StreamProvider<List<CollectionCard>>(
    (ref) => ref.watch(cardRepositoryProvider).watchAllWithCollection());

/// All entries keyed by (id, language) — one pass per emission so the
/// per-card family below gets O(1) lookups.
final _cardsByKeyProvider =
    Provider<AsyncValue<Map<(int, String), CollectionCard>>>((ref) =>
        ref.watch(allCardsProvider).whenData((entries) =>
            {for (final e in entries) (e.card.id, e.card.language): e}));

/// Single card entry by (id, language). Dependents rebuild only when that
/// entry changes — not on every collection mutation ([CollectionCard]
/// implements value equality for exactly this).
final cardEntryProvider =
    Provider.family<AsyncValue<CollectionCard?>, (int, String)>(
        (ref, key) => ref.watch(_cardsByKeyProvider).whenData((map) => map[key]));

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

/// Prebuilt scanner match index — rebuilt only when the card rows change.
/// Collection mutations (every "+1" during a scan session) re-emit through
/// [allCardsProvider] but must not pay for an index rebuild.
class MatchIndexNotifier extends Notifier<MatchIndex> {
  List<Card>? _lastCards;
  MatchIndex? _lastIndex;

  @override
  MatchIndex build() {
    final entries = ref.watch(allCardsProvider).valueOrNull ?? const [];
    final cards = [for (final e in entries) e.card];
    if (_lastIndex == null || !listEquals(_lastCards, cards)) {
      _lastCards = cards;
      _lastIndex = MatchIndex.fromCards(cards);
    }
    return _lastIndex!;
  }
}

final matchIndexProvider =
    NotifierProvider<MatchIndexNotifier, MatchIndex>(MatchIndexNotifier.new);

final scanProvider = NotifierProvider<ScanNotifier, ScanState>(
    () => ScanNotifier((ref) => ref.read(matchIndexProvider)));

/// Theme mode persisted in the settings table.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Load async, default to system until the stored value arrives.
    ref
        .watch(databaseProvider)
        .getSetting(SettingKeys.themeMode)
        .then((value) {
      final stored = ThemeMode.values
          .where((m) => m.name == value)
          .firstOrNull;
      if (stored != null) state = stored;
    });
    return ThemeMode.system;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(databaseProvider)
        .setSetting(SettingKeys.themeMode, mode.name);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
