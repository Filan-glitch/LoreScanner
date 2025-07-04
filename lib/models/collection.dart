import 'package:lorescanner/models/card.dart';

class Collection {
  final List<CollectionEntry> entries;

  Collection({required this.entries});

  CollectionEntry? getEntryByCard(Card card) {
    return entries.firstWhere(
      (entry) => entry.card.id == card.id,
      orElse: () => CollectionEntry(card: card),
    );
  }

  int get totalCards {
    return entries.fold(0, (sum, entry) => sum + entry.amount + entry.amountFoil);
  }

  void addCard(Card card, {int amount = 1, int amountFoil = 0}) {
    final entry = getEntryByCard(card);
    if (entry == null) {
      entries.add(CollectionEntry(card: card, amount: amount, amountFoil: amountFoil));
    } else {
      entries[entries.indexOf(entry)] = entry.copyWith(
        amount: entry.amount + amount,
        amountFoil: entry.amountFoil + amountFoil,
      );
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