import 'dart:core';

import 'package:lorescanner/models/card.dart';

class Collection {
  final List<CollectionEntry> entries;

  Collection({required this.entries});

  CollectionEntry? getEntryByCard(Card card) {
    try {
      return entries.firstWhere(
        (entry) => entry.card.id == card.id,
      );
    } catch (e) {
      return null;
    }
  }

  int get totalCards {
    return entries.fold(0, (sum, entry) => sum + entry.amount + entry.amountFoil);
  }

  void addCard(Card card, {int amount = 1, int amountFoil = 0}) {
    final entryIndex = entries.indexWhere((entry) => entry.card.id == card.id);

    if (entryIndex == -1) {
      entries.add(CollectionEntry(card: card, amount: amount, amountFoil: amountFoil));
    } else {
      final entry = entries[entryIndex];
      entries[entryIndex] = entry.copyWith(
        amount: entry.amount + amount,
        amountFoil: entry.amountFoil + amountFoil,
      );
    }
    entries.sort(collectionEntrySellFocusComparator);
  }

  void removeCard(Card card, {int amount = 1, int amountFoil = 0}) {
    final entryIndex = entries.indexWhere((entry) => entry.card.id == card.id);

    if (entryIndex != -1) {
      final entry = entries[entryIndex];
      final newAmount = entry.amount - amount;
      final newAmountFoil = entry.amountFoil - amountFoil;

      if (newAmount <= 0 && newAmountFoil <= 0) {
        entries.removeAt(entryIndex);
      } else {
        entries[entryIndex] = entry.copyWith(
          amount: newAmount > 0 ? newAmount : 0,
          amountFoil: newAmountFoil > 0 ? newAmountFoil : 0,
        );
      }
    }
  }
}

class CollectionEntry implements Comparable<CollectionEntry> {
  final Card card;
  final int amount;
  final int amountFoil;

  CollectionEntry({
    required this.card,
    this.amount = 0,
    this.amountFoil = 0,
  });

  copyWith({
    Card? card,
    int? amount,
    int? amountFoil,
  }) {
    return CollectionEntry(
      card: card ?? this.card,
      amount: amount ?? this.amount,
      amountFoil: amountFoil ?? this.amountFoil,
    );
  }

  @override
  int compareTo(CollectionEntry other) {
    // Sort by set number, then by card number
    final setComparison = this.card.setCode.compareTo(other.card.setCode);
    if (setComparison != 0) {
      return setComparison;
    }
    return this.card.number.compareTo(other.card.number);
  }
}

// Color order: 'Bernstein', 'Amethyst', 'Smaragd', 'Rubin', 'Saphir', 'Stahl'
// card.colors is a list, the color first in the color order is the primary color
int collectionEntrySellFocusComparator(CollectionEntry a, CollectionEntry b) {
  // Card without promo grouping befor promo grouped cards, if both cards are promo or not prome then:
  // Sort by color, then by cost, then by name

  if (a.card.promoGrouping == null && b.card.promoGrouping != null) {
    return -1; // a is not promo, b is promo
  }

  if (a.card.promoGrouping != null && b.card.promoGrouping == null) {
    return 1; // a is promo, b is not
  }

  // Both cards are either promo or not promo, sort by color
  final colorComparison = _compareColors(a.card.colors, b.card.colors);
  if (colorComparison != 0) {
    return colorComparison; // Sort by primary color
  }
  // If colors are the same, sort by cost
  final costComparison = a.card.cost.compareTo(b.card.cost);
  if (costComparison != 0) {
    return costComparison; // Sort by cost
  }
  // If cost is the same, sort by name
  return a.card.fullName.compareTo(b.card.fullName); // Sort by name
}

int _compareColors(List<String> colorsA, List<String> colorsB) {
  // Define the color order
  const colorOrder = [
    'Bernstein',
    'Amethyst',
    'Smaragd',
    'Rubin',
    'Saphir',
    'Stahl'
  ];

  // Get the primary color index for each card
  final indexA = colorsA.isNotEmpty ? colorOrder.indexOf(colorsA.first) : -1;
  final indexB = colorsB.isNotEmpty ? colorOrder.indexOf(colorsB.first) : -1;

  return indexA.compareTo(indexB);
}
