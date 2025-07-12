import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/models/collection.dart';
import 'package:lorescanner/models/price.dart';
import 'package:lorescanner/service/database.dart' as db;

class CardsProvider extends ChangeNotifier {
  List<Card> _cards = [];
  Collection _collection = Collection(entries: []);
  List<Price> _prices = [];
  bool _isLoadingCollection = false;

  List<Card> get cards => _cards;
  Collection get collection => _collection;
  List<Price> get prices => _prices;
  bool get isLoadingCollection => _isLoadingCollection;

  Future<void> loadCollection() async {
    _isLoadingCollection = true;
    notifyListeners();
    
    try {
      // Fetch all cards and the collection map
      final List<Card> allCards = await db.fetchCardsFromDB();
      final Map<int, Map<String, int>> collectionData = await db.fetchCollectionFromDB();
      final List<CollectionEntry> entries = [];

      for (final card in allCards) {
        final entryData = collectionData[card.id];
        if (entryData != null) {
          entries.add(CollectionEntry(
            card: card,
            amount: entryData['amount'] ?? 0,
            amountFoil: entryData['amountFoil'] ?? 0,
          ));
        }
      }

      _collection = Collection(entries: entries);
    } catch (e) {
      print('Error loading collection: $e');
      _collection = Collection(entries: []);
    }
    
    _isLoadingCollection = false;
    notifyListeners();
  }

  Future<void> addCardToCollection(Card card, {int amount = 1, int amountFoil = 0}) async {
    _collection.addCard(card, amount: amount, amountFoil: amountFoil);
    
    // Also persist to database
    try {
      await db.addCardToCollection(card.id, amount: amount, amountFoil: amountFoil);
    } catch (e) {
      print('Error persisting card to database: $e');
    }
    
    notifyListeners();
  }

  void setCards(List<Card> newCards) {
    _cards = newCards;
    notifyListeners();
  }

  void setCollection(Collection newCollection) {
    _collection = newCollection;
    notifyListeners();
  }

  void setPrices(List<Price> newPrices) {
    _prices = newPrices;
    notifyListeners();
  }

  void clearCards() {
    _cards = [];
    notifyListeners();
  }

  Future<void> refreshCollection() async {
    await loadCollection();
  }

  void clearCollection() {
    _collection = Collection(entries: []);
    notifyListeners();
  }
}
