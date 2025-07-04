import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/card.dart';

Future<Database> openDB() async {
  final String databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'lorcana.db');
  return openDatabase(
    path,
    version: 1,
    onCreate: (Database database, int version) async {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS cards (
          id INTEGER PRIMARY KEY,
          images TEXT,
          setCode TEXT,
          simpleName TEXT
        );
      ''');
      await database.execute(
        '''
        CREATE TABLE IF NOT EXISTS collection (
          cardId INTEGER PRIMARY KEY,
          amount INTEGER DEFAULT 0,
          amountFoil INTEGER DEFAULT 0,
          FOREIGN KEY (cardId) REFERENCES cards (id)
        );
        ''');
    },
  );
}

Future<void> insertCards(List<Card> cards) async {
  final Database db = await openDB();
  for (Card card in cards) {
    final map = card.toMap();
    await db.insert(
      'cards',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  await db.close();
}

Future<void> addCardToCollection(int cardId, {int amount = 1, int amountFoil = 0}) async {
  final Database db = await openDB();
  // Check if the card already exists in the collection
  final List<Map<String, dynamic>> existingCards = await db.query(
    'collection',
    where: 'cardId = ?',
    whereArgs: [cardId],
  );
  if (existingCards.isNotEmpty) {
    // If it exists, update the amount
    await db.update(
      'collection',
      {'amount': existingCards[0]['amount'] + amount, 'amountFoil': existingCards[0]['amountFoil'] + amountFoil},
      where: 'cardId = ?',
      whereArgs: [cardId],
    );
    await db.close();
    return;
  }
  await db.insert(
    'collection',
    {'cardId': cardId, 'amount': amount, 'amountFoil': amountFoil},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  await db.close();
}

Future<List<Card>> fetchCardsFromDB() async {
  final Database db = await openDB();
  final List<Map<String, dynamic>> maps = await db.query('cards');
  await db.close();

  return List.generate(maps.length, (i) {
    return CardMapper.fromMap(maps[i]);
  });
}

Future<Map<int, Map<String, int>>> fetchCollectionFromDB() async {
  final Database db = await openDB();
  final List<Map<String, dynamic>> maps = await db.query('collection');
  await db.close();

  Map<int, Map<String, int>> collection = {};
  for (var map in maps) {
    collection[map['cardId']] = {
      'amount': map['amount'],
      'amountFoil': map['amountFoil'],
    };
  }
  return collection;
}