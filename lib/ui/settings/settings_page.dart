import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants.dart';
import '../../core/logging.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/sync_service.dart';
import '../../domain/export/csv_exporter.dart';
import '../../providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(cardLanguageProvider).valueOrNull ?? 'de';
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          const _SectionHeader('Darstellung'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Design'),
            subtitle: Text(switch (themeMode) {
              ThemeMode.system => 'System',
              ThemeMode.light => 'Hell',
              ThemeMode.dark => 'Dunkel',
            }),
            onTap: () => _pickTheme(context, ref, themeMode),
          ),
          const _SectionHeader('Kartendaten'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Kartensprache'),
            subtitle: Text(language == 'de' ? 'Deutsch' : 'Englisch'),
            onTap: () => _pickLanguage(context, ref, language),
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Jetzt synchronisieren'),
            subtitle: const Text('Kartenliste und Preise aktualisieren'),
            onTap: () => _syncNow(context, ref),
          ),
          const _SectionHeader('Sammlung'),
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Als CSV exportieren'),
            subtitle: const Text('Dreamborn.ink-Format teilen'),
            onTap: () => _exportCsv(context, ref),
          ),
          const _SectionHeader('Links'),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Offizielle Lorcana-Website'),
            onTap: () => launchUrl(Uri.parse(officialWebsiteUrl),
                mode: LaunchMode.externalApplication),
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: const Text('Offizielle Companion-App'),
            onTap: () => launchUrl(Uri.parse(officialAppUrl),
                mode: LaunchMode.externalApplication),
          ),
          const _SectionHeader('Info'),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Lizenzen'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'LoreScanner',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.storage),
            title: Text('Datenquellen'),
            subtitle: Text('Kartendaten: lorcanajson.org · '
                'Preise: Cardmarket'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTheme(
      BuildContext context, WidgetRef ref, ThemeMode current) async {
    final mode = await showDialog<ThemeMode>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Design'),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (mode, label) in [
                  (ThemeMode.system, 'System'),
                  (ThemeMode.light, 'Hell'),
                  (ThemeMode.dark, 'Dunkel'),
                ])
                  RadioListTile<ThemeMode>(title: Text(label), value: mode),
              ],
            ),
          ),
        ],
      ),
    );
    if (mode != null) {
      await ref.read(themeModeProvider.notifier).set(mode);
    }
  }

  Future<void> _pickLanguage(
      BuildContext context, WidgetRef ref, String current) async {
    final language = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Kartensprache'),
        children: [
          RadioGroup<String>(
            groupValue: current,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (code, label) in [
                  ('de', 'Deutsch'),
                  ('en', 'Englisch'),
                ])
                  RadioListTile<String>(title: Text(label), value: code),
              ],
            ),
          ),
        ],
      ),
    );
    if (language == null || language == current) return;
    final db = ref.read(databaseProvider);
    await db.setSetting(SettingKeys.cardLanguage, language);
    if (context.mounted) _syncNow(context, ref, force: true);
  }

  Future<void> _syncNow(BuildContext context, WidgetRef ref,
      {bool force = true}) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
        const SnackBar(content: Text('Synchronisierung läuft…')));
    final result =
        await ref.read(syncServiceProvider).syncIfNeeded(force: force);
    await ref.read(priceRepositoryProvider).refreshIfStale(force: true);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(switch (result) {
        SyncResult.synced => 'Kartendaten aktualisiert',
        SyncResult.upToDate ||
        SyncResult.skipped =>
          'Kartendaten sind aktuell',
        _ => 'Synchronisierung fehlgeschlagen',
      }),
    ));
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final entries = ref.read(allCardsProvider).valueOrNull ?? const [];
      final csv = toDreambornInk(entries);
      final path = p.join(
          (await getApplicationCacheDirectory()).path, 'collection.csv');
      final file = File(path);
      await file.writeAsString(csv, flush: true);
      await SharePlus.instance.share(ShareParams(
        text: 'Sammlung exportiert',
        files: [XFile(path, mimeType: 'text/csv')],
      ));
    } catch (e, st) {
      log.warning('CSV export failed', e, st);
      messenger.showSnackBar(
          const SnackBar(content: Text('Export fehlgeschlagen')));
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
