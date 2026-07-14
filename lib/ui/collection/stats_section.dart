import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/collection_stats.dart';
import '../../providers.dart';

class StatsSection extends ConsumerWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(collectionStatsProvider).valueOrNull;
    if (stats == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat(context, 'Karten', '${stats.ownedUnique}',
                  Icons.credit_card),
              _divider(theme),
              _stat(context, 'Gesamt', '${stats.totalCopies}',
                  Icons.inventory_2),
              _divider(theme),
              _ValueStat(),
            ],
          ),
          if (stats.setCompletion.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SetCompletionRow(stats: stats),
          ],
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) => Container(
        height: 40,
        width: 1,
        color: theme.colorScheme.onPrimaryContainer.withAlpha(51),
      );

  Widget _stat(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final onContainer = theme.colorScheme.onPrimaryContainer;
    return Column(
      children: [
        Icon(icon, color: onContainer, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: onContainer),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: onContainer.withAlpha(204)),
        ),
      ],
    );
  }
}

class _ValueStat extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onContainer = theme.colorScheme.onPrimaryContainer;
    final value = ref.watch(collectionValueProvider).valueOrNull;
    return Tooltip(
      message: value == null || value.ownedCards == 0
          ? 'Noch keine Preise geladen'
          : 'Wert basiert auf ${value.pricedCards} von ${value.ownedCards} Karten',
      child: Column(
        children: [
          Icon(Icons.euro, color: onContainer, size: 24),
          const SizedBox(height: 4),
          Text(
            value == null ? '—' : value.total.toStringAsFixed(2),
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: onContainer),
          ),
          Text(
            'Wert',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: onContainer.withAlpha(204)),
          ),
        ],
      ),
    );
  }
}

class _SetCompletionRow extends StatelessWidget {
  const _SetCompletionRow({required this.stats});

  final CollectionStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onContainer = theme.colorScheme.onPrimaryContainer;
    final sets = stats.setCompletion.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final entry = sets[i];
          final owned = entry.value.owned;
          final total = entry.value.total;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Set ${entry.key}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: onContainer)),
              const SizedBox(height: 4),
              SizedBox(
                width: 72,
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : owned / total,
                  backgroundColor: onContainer.withAlpha(38),
                ),
              ),
              const SizedBox(height: 2),
              Text('$owned/$total',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: onContainer.withAlpha(204))),
            ],
          );
        },
      ),
    );
  }
}
