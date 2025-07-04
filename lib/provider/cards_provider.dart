import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/models/collection.dart';

class CardsProvider extends ChangeNotifier {
  List<Card> _cards = [];
  Collection _collection = Collection(entries: []);

  List<Card> get cards => _cards;

  Collection get collection => _collection;

  void addCardToCollection(Card card, {int amount = 1, int amountFoil = 0}) {
    _collection.addCard(card, amount: amount, amountFoil: amountFoil);
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

  void clearCards() {
    _cards = [];
    notifyListeners();
  }
}

