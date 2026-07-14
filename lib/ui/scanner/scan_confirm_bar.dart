import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/card_ext.dart';
import '../../providers.dart';

/// Quick-confirm strip shown while the stream keeps running: card preview,
/// +1 / +1 Foil / dismiss.
class ScanConfirmBar extends ConsumerWidget {
  const ScanConfirmBar({super.key, required this.cardId});

  final int cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entry = ref
        .watch(allCardsProvider)
        .valueOrNull
        ?.where((e) => e.card.id == cardId)
        .firstOrNull;
    if (entry == null) return const SizedBox.shrink();
    final card = entry.card;

    return Material(
      color: theme.colorScheme.surface.withAlpha(242),
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 67,
                child: card.thumbnailUrl == null
                    ? const ColoredBox(color: Colors.black12)
                    : CachedNetworkImage(
                        imageUrl: card.thumbnailUrl!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(card.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall),
                  Text('${card.setCode} · ${card.number}',
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => _confirm(ref, foil: false),
              child: const Text('+1'),
            ),
            const SizedBox(width: 4),
            FilledButton.tonal(
              onPressed: () => _confirm(ref, foil: true),
              child: const Text('+1 ✦'),
            ),
            IconButton(
              onPressed: () => ref.read(scanProvider.notifier).dismiss(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(WidgetRef ref, {required bool foil}) {
    final db = ref.read(databaseProvider);
    db.collectionDao.addCard(
      cardId,
      amount: foil ? 0 : 1,
      amountFoil: foil ? 1 : 0,
    );
    ref.read(scanProvider.notifier).confirmed(cardId);
  }
}
