import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/card_repository.dart';
import 'package:lorescanner/domain/export/csv_exporter.dart';

Card _card(int id,
    {String setCode = '1', int? number, String? promoGrouping}) {
  return Card(
    id: id,
    setCode: setCode,
    number: number ?? id,
    language: 'de',
    simpleName: 'c$id',
    fullName: 'c$id',
    searchName: 'c$id',
    rarity: 'common',
    type: 'character',
    story: '',
    ink: 'Amber',
    inksJson: '["Amber"]',
    cost: 1,
    inkwell: false,
    promoGrouping: promoGrouping,
    foilTypesJson: '[]',
    imagesJson: '{}',
    externalLinksJson: '{}',
    cardmarketId: null,
  );
}

void main() {
  test('matches legacy ExportService output format exactly', () {
    final csv = toDreambornInk([
      CollectionCard(card: _card(1, number: 12), amount: 3),
      CollectionCard(card: _card(2, number: 5), amount: 1, amountFoil: 2),
      CollectionCard(
          card: _card(3, setCode: '2', number: 20, promoGrouping: 'P1'),
          amountFoil: 1),
      CollectionCard(card: _card(4)), // not owned - excluded
    ]);

    expect(csv, 'Set Number,Card Number,Variant,Count\n'
        '1,12,normal,3\n'
        '1,5,normal,1\n'
        '1,5,foil,2\n'
        'P1,20,foil,1\n');
  });

  test('empty collection exports header only', () {
    expect(toDreambornInk(const []),
        'Set Number,Card Number,Variant,Count\n');
  });
}
