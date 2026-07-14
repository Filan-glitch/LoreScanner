import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/core/card_order.dart';

void main() {
  test('set codes sort numerically with Q-sets last', () {
    final codes = ['10', '2', 'Q1', '1', '13', 'Q2', '9'];
    codes.sort(compareSetCodes);
    expect(codes, ['1', '2', '9', '10', '13', 'Q1', 'Q2']);
  });

  test('rarities sort in canonical order (EN)', () {
    final rarities = [
      'Special', 'Enchanted', 'Common', 'Legendary', 'Rare',
      'Iconic', 'Uncommon', 'Epic', 'Super Rare',
    ];
    rarities.sort(compareRarities);
    expect(rarities, [
      'Common', 'Uncommon', 'Rare', 'Super Rare', 'Legendary',
      'Epic', 'Enchanted', 'Iconic', 'Special',
    ]);
  });

  test('rarities sort in canonical order (DE)', () {
    final rarities = [
      'Speziell', 'Verzaubert', 'Gewöhnlich', 'Legendär', 'Selten',
      'Ikonisch', 'Ungewöhnlich', 'Mythisch', 'Episch',
    ];
    rarities.sort(compareRarities);
    expect(rarities, [
      'Gewöhnlich', 'Ungewöhnlich', 'Selten', 'Episch', 'Legendär',
      'Mythisch', 'Verzaubert', 'Ikonisch', 'Speziell',
    ]);
  });

  test('unknown rarity sorts last', () {
    final rarities = ['Neuheit', 'Common'];
    rarities.sort(compareRarities);
    expect(rarities, ['Common', 'Neuheit']);
  });
}
