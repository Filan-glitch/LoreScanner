import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lorescanner/models/card.dart' as lore;

class FoundCardsOverview extends StatelessWidget {
  final List<lore.Card> foundCards;
  const FoundCardsOverview({super.key, required this.foundCards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wähle die korrekte Karte aus...')
      ),
      body: Stack(
        children: [
          BackdropFilter(
            blendMode: BlendMode.srcOver,
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            children: foundCards.map((card) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, {'card': card, 'foil': false}),
                child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image.network(card.images['full'] ?? '', fit: BoxFit.cover)
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}