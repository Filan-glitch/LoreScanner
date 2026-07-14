import 'package:drift/drift.dart';

/// Card definitions synced from lorcanajson — both languages permanently.
/// lorcanajson ids are printing-distinct but identical across languages,
/// so the primary key is (id, language). Complex fields stay JSON text;
/// the domain mapper decodes them.
class Cards extends Table {
  IntColumn get id => integer()();
  TextColumn get setCode => text()();
  IntColumn get number => integer()();
  TextColumn get language => text().withDefault(const Constant('de'))();
  TextColumn get simpleName => text()();
  TextColumn get fullName => text()();

  /// Pre-normalized via [normalizeName] — scanner matching key.
  TextColumn get searchName => text()();
  TextColumn get rarity => text()();
  TextColumn get type => text()();
  TextColumn get story => text()();

  /// Primary ink color; dual-ink cards carry the full list in [inksJson].
  TextColumn get ink => text().withDefault(const Constant(''))();
  TextColumn get inksJson => text().withDefault(const Constant('[]'))();
  IntColumn get cost => integer()();
  BoolColumn get inkwell => boolean()();
  TextColumn get promoGrouping => text().nullable()();
  TextColumn get foilTypesJson => text().withDefault(const Constant('[]'))();
  TextColumn get imagesJson => text().withDefault(const Constant('{}'))();
  TextColumn get externalLinksJson =>
      text().withDefault(const Constant('{}'))();

  /// Extracted from externalLinks.cardmarketId at sync time so prices join
  /// in SQL.
  IntColumn get cardmarketId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id, language};
}

/// Owned copies per physical card — language is part of the identity so a
/// German and an English print of the same card count separately.
class CollectionEntries extends Table {
  IntColumn get cardId => integer()();
  TextColumn get language => text().withDefault(const Constant('de'))();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  IntColumn get amountFoil => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {cardId, language};
}

class Prices extends Table {
  /// Cardmarket idProduct.
  IntColumn get cardmarketId => integer()();
  RealColumn get avg => real().nullable()();
  RealColumn get low => real().nullable()();
  RealColumn get trend => real().nullable()();
  RealColumn get avg1 => real().nullable()();
  RealColumn get avg7 => real().nullable()();
  RealColumn get avg30 => real().nullable()();
  RealColumn get avgFoil => real().nullable()();
  RealColumn get lowFoil => real().nullable()();
  RealColumn get trendFoil => real().nullable()();
  RealColumn get avg1Foil => real().nullable()();
  RealColumn get avg7Foil => real().nullable()();
  RealColumn get avg30Foil => real().nullable()();
  IntColumn get fetchedAt => integer()();

  @override
  Set<Column> get primaryKey => {cardmarketId};
}

/// Key-value app settings. Keys: cardLanguage, lastGeneratedOn.{lang},
/// lastSyncCheckAt, lastPriceFetchAt, priceGuideId, legacyImportDone.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
