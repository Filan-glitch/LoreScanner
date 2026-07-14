import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/sync_service.dart';
import '../../providers.dart';
import 'app_shell.dart';

/// Blocks on the startup future (legacy import + card sync). Only a failed
/// first-ever sync (empty DB) dead-ends into the retry screen — everything
/// else falls through to the app.
class SplashGate extends ConsumerWidget {
  const SplashGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(startupProvider);
    return startup.when(
      loading: () => const _SplashScreen(),
      error: (e, _) => _RetryScreen(onRetry: () => ref.refresh(startupProvider)),
      data: (result) => switch (result) {
        SyncResult.failedNoData =>
          _RetryScreen(onRetry: () => ref.refresh(startupProvider)),
        _ => const AppShell(),
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icon.png', width: 120, height: 120),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Kartendaten werden geladen…'),
          ],
        ),
      ),
    );
  }
}

class _RetryScreen extends StatelessWidget {
  const _RetryScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64),
            const SizedBox(height: 16),
            const Text('Kartendaten konnten nicht geladen werden.'),
            const SizedBox(height: 8),
            const Text('Bitte Internetverbindung prüfen.'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }
}
