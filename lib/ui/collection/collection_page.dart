import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../widgets/card_grid_tile.dart';
import 'filter_sheet.dart';
import 'stats_section.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredCardsProvider);
    final filter = ref.watch(collectionFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sammlung'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: !filter.isDefault,
              child: const Icon(Icons.filter_alt),
            ),
            tooltip: 'Sammlung filtern',
            onPressed: () => _openFilterSheet(context, ref),
          ),
        ],
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (cards) {
          if (cards.isEmpty) {
            return _EmptyState(filtered: !filter.isDefault);
          }
          return Column(
            children: [
              const StatsSection(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, i) => CardGridTile(entry: cards[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openFilterSheet(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(cardRepositoryProvider);
    final language = ref.read(cardLanguageProvider).valueOrNull ?? 'de';
    final sets = await repo.setCodes(language);
    final rarities = await repo.rarities(language);
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(sets: sets, rarities: rarities),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              filtered
                  ? Icons.filter_alt_off
                  : Icons.collections_bookmark_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              filtered
                  ? 'Keine Karten entsprechen dem Filter'
                  : 'Deine Sammlung ist leer',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              filtered
                  ? 'Passe den Filter an oder setze ihn zurück.'
                  : 'Scanne Karten, um sie zu deiner Sammlung hinzuzufügen',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
