import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  group('CollectionDao', () {
    test('addCard creates entry, second add accumulates', () async {
      await db.collectionDao.addCard(1, amount: 2);
      await db.collectionDao.addCard(1, amount: 1, amountFoil: 3);
      final entry = await db.collectionDao.byCardId(1);
      expect(entry!.amount, 3);
      expect(entry.amountFoil, 3);
    });

    test('removeCard decrements, deletes at zero', () async {
      await db.collectionDao.addCard(1, amount: 2, amountFoil: 1);
      await db.collectionDao.removeCard(1, amount: 1);
      expect((await db.collectionDao.byCardId(1))!.amount, 1);
      await db.collectionDao.removeCard(1, amount: 1, amountFoil: 1);
      expect(await db.collectionDao.byCardId(1), isNull);
    });

    test('removeCard never goes negative', () async {
      await db.collectionDao.addCard(1, amount: 1, amountFoil: 5);
      await db.collectionDao.removeCard(1, amount: 10);
      final entry = await db.collectionDao.byCardId(1);
      expect(entry!.amount, 0);
      expect(entry.amountFoil, 5);
    });

    test('removeCard on missing card is a no-op', () async {
      await db.collectionDao.removeCard(99);
      expect(await db.collectionDao.byCardId(99), isNull);
    });
  });

  group('legacy import', () {
    test('reads collection rows from legacy sqflite fixture', () async {
      final dir = Directory.systemTemp.createTempSync('legacy_db');
      final path = '${dir.path}${Platform.pathSeparator}lorcana.db';
      final legacy = sqlite3.sqlite3.open(path);
      legacy.execute('''
        CREATE TABLE collection (
          cardId INTEGER PRIMARY KEY,
          amount INTEGER DEFAULT 0,
          amountFoil INTEGER DEFAULT 0
        );
      ''');
      legacy.execute('INSERT INTO collection VALUES (1, 2, 0), (7, 0, 1)');
      legacy.close();

      final rows = AppDatabase.importLegacyCollectionFrom(path);
      expect(rows, hasLength(2));
      expect(rows.first, (cardId: 1, amount: 2, amountFoil: 0));

      await db.collectionDao.importLegacyRows(rows);
      expect((await db.collectionDao.byCardId(7))!.amountFoil, 1);

      dir.deleteSync(recursive: true);
    });

    test('import ignores conflicts with existing entries', () async {
      await db.collectionDao.addCard(1, amount: 5);
      await db.collectionDao
          .importLegacyRows([(cardId: 1, amount: 2, amountFoil: 0)]);
      // insertOrIgnore: existing (newer) entry wins.
      expect((await db.collectionDao.byCardId(1))!.amount, 5);
    });
  });
}
