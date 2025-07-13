import 'package:cached_network_image/cached_network_image.dart';
import 'package:lorescanner/models/card.dart' as lore;
import 'package:flutter/material.dart';
import 'package:lorescanner/pages/card_detail_page.dart';

class CollectionItem extends StatelessWidget {
  final lore.Card item;
  const CollectionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailPage(card: item),
          ),
        );
      },
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: item.images['thumbnail'] ?? '',
            width: 100,
            height: 140,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 100,
              height: 140,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 100,
              height: 140,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
