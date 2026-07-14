import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/core/normalize.dart';

void main() {
  group('normalizeName', () {
    test('lowercases and trims', () {
      expect(normalizeName('  Arielle  '), 'arielle');
    });

    test('folds German umlauts and ß', () {
      expect(normalizeName('Mächtiger Zauberer'), 'maechtiger zauberer');
      expect(normalizeName('Weiße Rose'), 'weisse rose');
      expect(normalizeName('Übeltäter'), 'uebeltaeter');
    });

    test('strips punctuation, keeps digits', () {
      expect(normalizeName('Arielle - Singende Sirene!'),
          'arielle singende sirene');
      expect(normalizeName('R2-D2'), 'r2d2');
    });

    test('collapses whitespace', () {
      expect(normalizeName('a   b\t c'), 'a b c');
    });

    test('folds accents', () {
      expect(normalizeName('Café Naïve'), 'cafe naive');
    });
  });
}
