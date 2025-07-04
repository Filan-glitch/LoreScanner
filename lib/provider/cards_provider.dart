import 'dart:convert';
import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/models/collection.dart';
import 'package:lorescanner/service/database.dart' as db;

class CardsProvider extends ChangeNotifier {
  List<Card> _cards = [];
  Collection _collection = Collection(entries: []);
  bool _isLoadingCollection = false;

  List<Card> get cards => _cards;
  Collection get collection => _collection;
  bool get isLoadingCollection => _isLoadingCollection;

  Future<void> loadCollection() async {
    _isLoadingCollection = true;
    notifyListeners();
    
    try {
      final collectionData = await db.fetchCollectionFromDB();
      final List<CollectionEntry> entries = collectionData.map((data) {
        // Parse images - they're stored as JSON strings in the database
        Map<String, String> images = {};
        try {
          if (data['images'] is String) {
            final Map<String, dynamic> imageMap = jsonDecode(data['images'] as String);
            images = imageMap.cast<String, String>();
          } else if (data['images'] is Map) {
            images = (data['images'] as Map).cast<String, String>();
          }
        } catch (e) {
          print('Error parsing images for card ${data['id']}: $e');
          images = {};
        }
        
        final card = Card(
          id: data['id'],
          setCode: data['setCode'] ?? '',
          simpleName: data['simpleName'] ?? '',
          images: images,
          language: data['language'] ?? 'de',
        );
        return CollectionEntry(
          card: card,
          amount: data['amount'] ?? 0,
          amountFoil: data['amountFoil'] ?? 0,
        );
      }).toList();
      
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

