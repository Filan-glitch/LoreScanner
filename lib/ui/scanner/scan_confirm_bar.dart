import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/card_repository.dart';
import '../../domain/models/card_ext.dart';
import '../../providers.dart';

/// Quick-confirm strip shown while the stream keeps running: card preview,
/// +1 / +1 Foil / dismiss.
class ScanConfirmBar extends ConsumerWidget {
  const ScanConfirmBar({
    super.key,
    required this.cardId,
    required this.language,
  });

  final int cardId;
  final String language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entry =
        ref.watch(cardEntryProvider((cardId, language))).valueOrNull;
    if (entry == null) return const SizedBox.shrink();
    final card = entry.card;
    final prints = ref
            .watch(sameNamePrintsProvider((cardId, language)))
            .valueOrNull ??
        const <CollectionCard>[];

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
                        imageUrl: card.thumbnailUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth:
                            (48 * MediaQuery.devicePixelRatioOf(context))
                                .round(),
                      ),
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
                  _PrintLine(current: entry, prints: prints),
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
              tooltip: 'Verwerfen',
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(WidgetRef ref, {required bool foil}) {
    ref.read(cardRepositoryProvider).addCard(
          cardId,
          language,
          amount: foil ? 0 : 1,
          amountFoil: foil ? 1 : 0,
        );
    ref.read(scanProvider.notifier).confirmed(cardId, language);
  }
}

/// Set · number · language line. Same-name reprints exist in other sets:
/// becomes a dropdown so a footer misread is fixed with one tap instead of
/// dismiss + rescan.
class _PrintLine extends ConsumerWidget {
  const _PrintLine({required this.current, required this.prints});

  final CollectionCard current;
  final List<CollectionCard> prints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final card = current.card;
    final label =
        '${card.setCode} · ${card.number} · ${card.language.toUpperCase()}';
    if (prints.length < 2) {
      return Text(label, style: theme.textTheme.bodySmall);
    }
    return PopupMenuButton<(int, String)>(
      tooltip: 'Anderen Druck wählen',
      padding: EdgeInsets.zero,
      onSelected: (key) =>
          ref.read(scanProvider.notifier).switchPrint(key.$1, key.$2),
      itemBuilder: (context) => [
        for (final p in prints)
          CheckedPopupMenuItem<(int, String)>(
            value: (p.card.id, p.card.language),
            checked: p.card.id == card.id,
            child: Text(
                'Set ${p.card.setCode} · ${p.card.number} · ${p.card.rarity}'),
          ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.primary)),
          Icon(Icons.arrow_drop_down,
              size: 18, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}
