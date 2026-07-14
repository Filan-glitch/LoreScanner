import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/card_repository.dart';
import '../../domain/models/card_ext.dart';
import '../collection/card_detail_page.dart';

class CardGridTile extends StatelessWidget {
  const CardGridTile({super.key, required this.entry});

  final CollectionCard entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = entry.card.thumbnailUrl;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CardDetailPage(cardId: entry.card.id),
        ),
      ),
      child: Stack(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox.expand(
              child: url == null
                  ? const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.image_not_supported),
                    )
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child:
                            const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.error),
                      ),
                    ),
            ),
          ),
          if (entry.isOwned)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.amountFoil > 0
                      ? '${entry.amount}+${entry.amountFoil}✦'
                      : '${entry.amount}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            )
          else
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(115),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
