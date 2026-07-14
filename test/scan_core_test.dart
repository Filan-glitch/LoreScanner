import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/domain/scan/card_matcher.dart';
import 'package:lorescanner/domain/scan/match_index.dart';
import 'package:lorescanner/domain/scan/ocr_parser.dart';
import 'package:lorescanner/domain/scan/roi_mapper.dart';

void main() {
  group('parseFooterLine', () {
    test('full footer with bullet separators', () {
      final footer = parseFooterLine('4a/204 • DE • 3')!;
      expect(footer.number, 4);
      expect(footer.totalSegment, '204');
      expect(footer.language, 'DE');
      expect(footer.setCode, '3');
      expect(footer.isPromo, isFalse);
    });

    test('promo footer carries P-segment', () {
      final footer = parseFooterLine('20/P1 • DE • 1')!;
      expect(footer.number, 20);
      expect(footer.totalSegment, 'P1');
      expect(footer.isPromo, isTrue);
    });

    test('OCR-mangled separators (dot, dash, missing)', () {
      expect(parseFooterLine('105/204 . DE . 7')!.setCode, '7');
      expect(parseFooterLine('105/204 - DE - 7')!.setCode, '7');
      expect(parseFooterLine('105/204 DE 7')!.setCode, '7');
    });

    test('partial read: number/total only', () {
      final footer = parseFooterLine('205/204')!;
      expect(footer.number, 205);
      expect(footer.language, isNull);
      expect(footer.setCode, isNull);
    });

    test('Q-set footer', () {
      final footer = parseFooterLine('1/31 • DE • Q1')!;
      expect(footer.setCode, 'Q1');
    });

    test('rejects non-footer text', () {
      expect(parseFooterLine('Arielle Singende Sirene'), isNull);
    });
  });

  group('parseOcrLines', () {
    const roi = Rect.fromLTWH(0, 0, 300, 420);

    test('splits name band and footer band, ignores outside-ROI', () {
      final parsed = parseOcrLines([
        const OcrLine('ARIELLE', Rect.fromLTWH(60, 30, 180, 24)),
        const OcrLine('Singende Sirene', Rect.fromLTWH(60, 60, 180, 20)),
        const OcrLine('Sturmesschwingen kostet 1', // ability text, mid-card
            Rect.fromLTWH(40, 250, 220, 16)),
        const OcrLine('12/204 • DE • 2', Rect.fromLTWH(20, 395, 120, 14)),
        const OcrLine('Outside', Rect.fromLTWH(500, 30, 80, 20)),
      ], roi);

      expect(parsed.nameCandidates, contains('arielle'));
      expect(parsed.nameCandidates, contains('singende sirene'));
      expect(parsed.nameCandidates.join(' '), isNot(contains('sturm')));
      expect(parsed.footer!.number, 12);
      expect(parsed.nameCandidates.join(' '), isNot(contains('outside')));
    });

    test('rejects digit-heavy and tiny name lines', () {
      final parsed = parseOcrLines([
        const OcrLine('12 34 5', Rect.fromLTWH(60, 30, 180, 24)),
        const OcrLine('ab', Rect.fromLTWH(60, 60, 180, 20)),
      ], roi);
      expect(parsed.nameCandidates, isEmpty);
    });
  });

  group('matchCards', () {
    final index = MatchIndex.build(const [
      IndexEntry(cardId: 1, searchName: 'arielle singende sirene', setCode: '1', number: 1),
      IndexEntry(cardId: 2, searchName: 'arielle stimme des volkes', setCode: '2', number: 12),
      IndexEntry(cardId: 3, searchName: 'maechtiger zauberer', setCode: '5', number: 42),
      // Same name, different printings (normal vs promo).
      IndexEntry(cardId: 4, searchName: 'elsa schneekoenigin', setCode: '1', number: 20),
      IndexEntry(cardId: 5, searchName: 'elsa schneekoenigin', setCode: '1', number: 20, promoGrouping: 'P1'),
    ]);

    MatchResult? match(List<String> names, {FooterInfo? footer}) =>
        matchCards(MatchInput(
          parsed: ParsedOcr(nameCandidates: names, footer: footer),
          index: index,
        ));

    test('exact name match', () {
      final result = match(['arielle singende sirene'])!;
      expect(result.cardId, 1);
      expect(result.score, 1.0);
    });

    test('fuzzy match tolerates OCR noise', () {
      final result = match(['maechtiqer zauberer'])!; // g -> q misread
      expect(result.cardId, 3);
      expect(result.score, greaterThanOrEqualTo(0.7));
    });

    test('no match below threshold', () {
      expect(match(['voellig anderer text hier']), isNull);
    });

    test('same-name printings are ambiguous without footer', () {
      expect(match(['elsa schneekoenigin']), isNull);
    });

    test('footer pins exact printing among same-name cards', () {
      final promo = match(
        ['elsa schneekoenigin'],
        footer: const FooterInfo(
            number: 20, totalSegment: 'P1', language: 'DE', setCode: '1'),
      )!;
      expect(promo.cardId, 5);

      final normal = match(
        ['elsa schneekoenigin'],
        footer: const FooterInfo(
            number: 20, totalSegment: '204', language: 'DE', setCode: '1'),
      )!;
      expect(normal.cardId, 4);
    });

    test('footer-only identification without readable name', () {
      final result = match(
        [],
        footer: const FooterInfo(
            number: 42, totalSegment: '204', language: 'DE', setCode: '5'),
      )!;
      expect(result.cardId, 3);
      expect(result.score, 0.9);
    });

    test('footer alone without set code stays null when number ambiguous',
        () {
      // Number 20 exists twice (normal + promo) — totalSegment resolves it.
      final result = match(
        [],
        footer: const FooterInfo(number: 20, totalSegment: '204'),
      );
      expect(result!.cardId, 4);
    });
  });

  group('RoiMapper', () {
    test('cover-fit mapping round-trips', () {
      final mapper = RoiMapper(
        widgetSize: const Size(400, 800),
        uprightImageSize: const Size(1080, 1920),
      );
      const widgetRect = Rect.fromLTWH(40, 100, 320, 448);
      final imageRect = mapper.widgetToImage(widgetRect);
      final back = mapper.imageToWidget(imageRect);
      expect(back.left, closeTo(widgetRect.left, 0.001));
      expect(back.top, closeTo(widgetRect.top, 0.001));
      expect(back.width, closeTo(widgetRect.width, 0.001));
    });

    test('image ROI is centered horizontally for tall widget over wide image',
        () {
      // widget 400x800, image 1080x1920: scale = max(0.370, 0.4166) = 0.4166
      // displayed width = 450 -> 25px cropped each side.
      final mapper = RoiMapper(
        widgetSize: const Size(400, 800),
        uprightImageSize: const Size(1080, 1920),
      );
      final imageRect =
          mapper.widgetToImage(const Rect.fromLTWH(0, 0, 400, 800));
      expect(imageRect.left, greaterThan(0));
      expect(imageRect.width, closeTo(400 / (800 / 1920), 0.01));
    });

    test('uprightSize swaps dimensions for 90/270', () {
      expect(RoiMapper.uprightSize(const Size(1920, 1080), 90),
          const Size(1080, 1920));
      expect(RoiMapper.uprightSize(const Size(1920, 1080), 180),
          const Size(1920, 1080));
    });

    test('cardRoi keeps card aspect and stays inside widget', () {
      final roi = cardRoi(const Size(400, 800));
      expect(roi.width / roi.height, closeTo(63 / 88, 0.001));
      expect(roi.width, 320);
      expect(roi.center.dx, 200);
    });
  });
}
