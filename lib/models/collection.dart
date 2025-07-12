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

class CollectionEntry {
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
}