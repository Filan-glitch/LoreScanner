import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/models/collection.dart';
import 'package:lorescanner/models/price.dart';
import 'package:lorescanner/service/database.dart' as db;
import 'package:lorescanner/service/logging.dart';

import '../constants.dart';

class CardsProvider extends ChangeNotifier {
  List<Card> _cards = [];
  Collection _collection = Collection(entries: []);
  Collection _filteredCollection = Collection(entries: []);
  List<Price> _prices = [];
  bool _isLoadingCollection = false;
  bool _showOnlyMyCards = false;
  final Map<String, Set<dynamic>> filterMap = {};
  final Map<String, Set<dynamic>> activeFilters = {};

  List<Card> get cards => _cards;
  Collection get collection => _filteredCollection;
  List<Price> get prices => _prices;
  bool get isLoadingCollection => _isLoadingCollection;
  bool get showOnlyMyCards => _showOnlyMyCards;

  void _extractFilterOptions() {
    for (final attribute in filterAttributes) {
      filterMap[attribute] = <dynamic>{};
    }

    for (final card in cards) {
      final cardMap = card.toMap();
      for (final attribute in filterAttributes) {
        if (cardMap.containsKey(attribute) && cardMap[attribute] != null) {
          filterMap[attribute]!.add(cardMap[attribute]);
        }
      }
    }
  }

  Future<void> loadCollection() async {
    _isLoadingCollection = true;
    notifyListeners();
    try {
      final List<Card> allCards = await db.fetchCardsFromDB();
      final Map<int, Map<String, int>> collectionData = await db.fetchCollectionFromDB();
      final List<CollectionEntry> entries = [];

      for (final card in allCards) {
        final entryData = collectionData[card.id];
        entries.add(CollectionEntry(
          card: card,
          amount: entryData?['amount'] ?? 0,
          amountFoil: entryData?['amountFoil'] ?? 0,
        ));
      }

      _cards = allCards;
      _collection = Collection(entries: entries);
      _filteredCollection = _collection;
      _extractFilterOptions();
    } catch (e, st) {
      log.severe('Error loading collection', e, st);
      _collection = Collection(entries: []);
      _filteredCollection = Collection(entries: []);
    }
    _isLoadingCollection = false;
    notifyListeners();
  }

  Future<void> addCardToCollection(Card card, {int amount = 0, int amountFoil = 0}) async {
    _collection.addCard(card, amount: amount, amountFoil: amountFoil);
    
    // Also persist to database
    try {
      await db.addCardToCollection(card.id, amount: amount, amountFoil: amountFoil);
    } catch (e, st) {
      log.severe('Error persisting card to database', e, st);
    }
    
    notifyListeners();
  }

  Future<void> removeCardFromCollection(Card card, {int amount = 0, int amountFoil = 0}) async {
    _collection.removeCard(card, amount: amount, amountFoil: amountFoil);

    // Also persist to database
    try {
      await db.removeCardFromCollection(card.id, amount: amount, amountFoil: amountFoil);
    } catch (e, st) {
      log.severe('Error persisting card removal to database', e, st);
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
    _filteredCollection = Collection(entries: []);
    notifyListeners();
  }

  void applyFilters(Map<String, Set<dynamic>> newFilters) {
    activeFilters.clear();
    activeFilters.addAll(newFilters);

    _applyFilter();
    notifyListeners();
  }

  void toggleShowOnlyMyCards() {
    _showOnlyMyCards = !_showOnlyMyCards;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    List<CollectionEntry> entriesToFilter = _collection.entries;

    if (_showOnlyMyCards) {
      entriesToFilter = entriesToFilter.where((entry) => entry.amount > 0 || entry.amountFoil > 0).toList();
    }

    if (activeFilters.isEmpty) {
      _filteredCollection = Collection(entries: entriesToFilter);
    } else {
      final filteredEntries = entriesToFilter.where((entry) {
        final cardMap = entry.card.toMap();
        return activeFilters.entries.every((filterEntry) {
          final cardValue = cardMap[filterEntry.key];
          return filterEntry.value.contains(cardValue);
        });
      }).toList();
      _filteredCollection = Collection(entries: filteredEntries);
    }
  }

  void resetFilters() {
    activeFilters.clear();
    _filteredCollection = _collection;
    notifyListeners();
  }
}
