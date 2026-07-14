import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'data/api/lorcana_api.dart';
import 'data/db/app_database.dart';
import 'data/repositories/sync_service.dart';

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
