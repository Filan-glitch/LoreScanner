import 'package:flutter/material.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    final collection = cardsProvider.collection;
    
    if (cardsProvider.isLoadingCollection) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (collection.entries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections_bookmark_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Deine Sammlung ist leer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Scanne Karten, um sie zu deiner Sammlung hinzuzufügen',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${collection.entries.length} verschiedene Karten',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Gesamt: ${collection.totalCards}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: collection.entries.length,
            itemBuilder: (context, index) {
              final entry = collection.entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(entry.card.simpleName)),
                      const SizedBox(width: 8),
                      if (entry.amount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'x${entry.amount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (entry.amountFoil > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Foil x${entry.amountFoil}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(entry.card.setCode),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: entry.card.images['thumbnail'] != null
                        ? Image.network(
                            entry.card.images['thumbnail']!,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        : const Icon(Icons.image_not_supported),
                  ),
                  onTap: () {
                    // Navigate to card detail page or perform any action
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetailPage(card: card)));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
