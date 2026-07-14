import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/data/db/app_database.dart';
import 'package:lorescanner/data/repositories/card_repository.dart';
import 'package:lorescanner/domain/export/csv_exporter.dart';

Card _card(int id,
    {String setCode = '1',
    int? number,
    String? promoGrouping,
    String language = 'de'}) {
  return Card(
    id: id,
    setCode: setCode,
    number: number ?? id,
    language: language,
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

  test('malicious set segment is quoted and formula-neutralized', () {
    final csv = toDreambornInk([
      CollectionCard(
          card: _card(1, number: 7, promoGrouping: '=1+1,"x"\nY'), amount: 1),
      CollectionCard(
          card: _card(2, number: 8, promoGrouping: '+SUM(A1)'), amount: 1),
    ]);
    expect(csv, 'Set Number,Card Number,Variant,Count\n'
        '"\'=1+1,""x""\nY",7,normal,1\n'
        "'+SUM(A1),8,normal,1\n");
  });

  test('DE and EN copies of the same printing are summed', () {
    final csv = toDreambornInk([
      CollectionCard(card: _card(1, number: 12), amount: 2),
      CollectionCard(
          card: _card(1, number: 12, language: 'en'), amount: 1, amountFoil: 1),
    ]);
    expect(csv, 'Set Number,Card Number,Variant,Count\n'
        '1,12,normal,3\n'
        '1,12,foil,1\n');
  });
}
