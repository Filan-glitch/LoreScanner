// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prices_dao.dart';

// ignore_for_file: type=lint
mixin _$PricesDaoMixin on DatabaseAccessor<AppDatabase> {
  $PricesTable get prices => attachedDatabase.prices;
  PricesDaoManager get managers => PricesDaoManager(this);
}

class PricesDaoManager {
  final _$PricesDaoMixin _db;
  PricesDaoManager(this._db);
  $$PricesTableTableManager get prices =>
      $$PricesTableTableManager(_db.attachedDatabase, _db.prices);
}
