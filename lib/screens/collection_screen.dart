import 'package:flutter/material.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    final collection = cardsProvider.collection;
    return ListView.builder(
      itemCount: collection.entries.length,
      itemBuilder: (context, index) {
        final entry = collection.entries[index];
        return ListTile(
          title: Row(
            children: [
              Text(entry.card.simpleName),
              Spacer(),
              Text('x${entry.amount}'),
              if (entry.amountFoil > 0) Text(' (Foil: x${entry.amountFoil})'),
            ],
          ),
          subtitle: Text(entry.card.setCode),
          leading: entry.card.images['thumbnail'] != null
              ? Image.network(entry.card.images['thumbnail']!)
              : const Icon(Icons.image_not_supported),
          onTap: () {
            // Navigate to card detail page or perform any action
            // Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetailPage(card: card)));
          },
        );
      },
    );
  }
}
