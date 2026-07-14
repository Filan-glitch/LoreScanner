import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/card_repository.dart';
import '../../domain/models/card_ext.dart';
import '../../providers.dart';

class CardDetailPage extends ConsumerWidget {
  const CardDetailPage({super.key, required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(allCardsProvider).valueOrNull;
    final entry = entries?.where((e) => e.card.id == cardId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Detailansicht')),
      body: entry == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardImage(entry: entry),
                  _CardHeader(entry: entry),
                  _CollectionEdit(entry: entry),
                  _PricesSection(entry: entry),
                  _AttributesSection(entry: entry),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = entry.card.fullImageUrl;
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: url == null
            ? Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.image_not_supported)),
              )
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, _, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: Text('Bild nicht verfügbar')),
                ),
              ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = entry.card;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.fullName, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Set ${card.setCode} · Nr. ${card.number}')),
              Chip(label: Text(card.rarity)),
              if (card.ink.isNotEmpty) Chip(label: Text(card.ink)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CollectionEdit extends ConsumerWidget {
  const _CollectionEdit({required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _stepper(
            context,
            label: 'Normal',
            value: entry.amount,
            onAdd: () => db.collectionDao.addCard(entry.card.id),
            onRemove: () => db.collectionDao.removeCard(entry.card.id),
          ),
          const SizedBox(height: 8),
          _stepper(
            context,
            label: 'Foil ✦',
            value: entry.amountFoil,
            onAdd: () =>
                db.collectionDao.addCard(entry.card.id, amount: 0, amountFoil: 1),
            onRemove: () => db.collectionDao
                .removeCard(entry.card.id, amount: 0, amountFoil: 1),
          ),
        ],
      ),
    );
  }

  Widget _stepper(
    BuildContext context, {
    required String label,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        IconButton.filledTonal(
          onPressed: value > 0 ? onRemove : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
        IconButton.filledTonal(onPressed: onAdd, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class _PricesSection extends ConsumerWidget {
  const _PricesSection({required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cmId = entry.card.cardmarketId;
    final price =
        cmId == null ? null : ref.watch(pricesMapProvider).valueOrNull?[cmId];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cardmarket-Preise', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (price == null)
            const Text('Kein Preis verfügbar')
          else ...[
            for (final row in _rows(price))
              if (row.value != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(child: Text(row.key)),
                      Text('${row.value!.toStringAsFixed(2)} €',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            const SizedBox(height: 8),
            Text(
              'Stand: ${_formatDate(price.fetchedAt)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  List<MapEntry<String, double?>> _rows(Price price) => [
        MapEntry('Durchschnitt', price.avg),
        MapEntry('Niedrigster', price.low),
        MapEntry('Trend', price.trend),
        MapEntry('Durchschnitt 1 Tag', price.avg1),
        MapEntry('Durchschnitt 7 Tage', price.avg7),
        MapEntry('Durchschnitt 30 Tage', price.avg30),
        MapEntry('Durchschnitt (Foil)', price.avgFoil),
        MapEntry('Niedrigster (Foil)', price.lowFoil),
        MapEntry('Trend (Foil)', price.trendFoil),
        MapEntry('Durchschnitt 1 Tag (Foil)', price.avg1Foil),
        MapEntry('Durchschnitt 7 Tage (Foil)', price.avg7Foil),
        MapEntry('Durchschnitt 30 Tage (Foil)', price.avg30Foil),
      ];

  static String _formatDate(int ms) {
    final date = DateTime.fromMillisecondsSinceEpoch(ms);
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _AttributesSection extends StatelessWidget {
  const _AttributesSection({required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = entry.card;
    final attributes = <MapEntry<String, String>>[
      MapEntry('Typ', card.type),
      MapEntry('Geschichte', card.story),
      MapEntry('Kosten', '${card.cost}'),
      MapEntry('Tintenfass', card.inkwell ? 'Ja' : 'Nein'),
      if (card.inks.length > 1) MapEntry('Tinten', card.inks.join(', ')),
      if (card.promoGrouping != null) MapEntry('Promo', card.promoGrouping!),
      if (card.foilTypes.isNotEmpty)
        MapEntry('Foil-Varianten', card.foilTypes.join(', ')),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Eigenschaften', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final attribute in attributes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(attribute.key,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Text(attribute.value)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
