import 'dart:math';
import 'dart:ui';

import '../../core/normalize.dart';

/// Parsed card footer, e.g. `4a/204 • DE • 3` or `20/P1 • DE • 1`.
///
/// [totalSegment] disambiguates printings: promo cards share (setCode,
/// number) with normal cards but carry their promoGrouping (`P1`…) as the
/// total, while regular cards show the set size (`204`).
class FooterInfo {
  const FooterInfo({
    required this.number,
    required this.totalSegment,
    this.language,
    this.setCode,
  });

  final int number;
  final String totalSegment;
  final String? language;
  final String? setCode;

  bool get isPromo => totalSegment.startsWith('P');

  @override
  String toString() =>
      'FooterInfo($number/$totalSegment ${language ?? '?'} ${setCode ?? '?'})';
}

/// A recognized text line with its position (image coordinates).
class OcrLine {
  const OcrLine(this.text, this.boundingBox);

  final String text;
  final Rect boundingBox;
}

/// Result of splitting OCR output into scanner-relevant candidates.
class ParsedOcr {
  const ParsedOcr({required this.nameCandidates, this.footer});

  /// Normalized (via [normalizeName]) candidate card names.
  final List<String> nameCandidates;
  final FooterInfo? footer;
}

/// The card name sits in the upper band of the card ROI.
const double _nameBandFraction = 0.45;

/// The footer identifier sits in the bottom band.
const double _footerBandFraction = 0.22;

// OCR reads the bullet separator as ·, •, *, ., -, or drops it entirely.
final RegExp _footerPattern = RegExp(
  r'(\d{1,3})[a-zA-Z]?\s*/\s*([A-Za-z]?\d{1,3})' // 4a/204 or 20/P1
  r'(?:\s*[·•*.\-–—]?\s*([A-Z]{2}))?' // DE
  r'(?:\s*[·•*.\-–—]?\s*([A-Z]?\d{1,2}))?', // set code 3 / Q1
);

/// Parses one line as a card footer. Tolerates partial reads — number/total
/// alone is still useful.
FooterInfo? parseFooterLine(String line) {
  final match = _footerPattern.firstMatch(line);
  if (match == null) return null;
  final number = int.tryParse(match.group(1)!);
  if (number == null) return null;
  return FooterInfo(
    number: number,
    totalSegment: match.group(2)!.toUpperCase(),
    language: match.group(3),
    setCode: match.group(4),
  );
}

/// Splits OCR lines (with image-space bounding boxes) inside [roi] into name
/// candidates and a footer.
ParsedOcr parseOcrLines(List<OcrLine> lines, Rect roi) {
  final nameBandBottom = roi.top + roi.height * _nameBandFraction;
  final footerBandTop = roi.bottom - roi.height * _footerBandFraction;

  final names = <String>[];
  FooterInfo? footer;

  for (final line in lines) {
    final center = line.boundingBox.center;
    if (!roi.contains(center)) continue;

    if (center.dy >= footerBandTop) {
      footer ??= parseFooterLine(line.text);
      continue;
    }

    if (center.dy <= nameBandBottom) {
      final candidate = _nameCandidate(line.text);
      if (candidate != null) names.add(candidate);
    }
  }

  // Wider lines are more likely the big name print — try longest first.
  names.sort((a, b) => b.length.compareTo(a.length));
  return ParsedOcr(nameCandidates: names.take(5).toList(), footer: footer);
}

String? _nameCandidate(String raw) {
  final trimmed = raw.trim();
  if (trimmed.length < 3 || trimmed.length > 40) return null;
  final letters = trimmed.runes
      .where((r) =>
          (r >= 0x41 && r <= 0x5a) ||
          (r >= 0x61 && r <= 0x7a) ||
          r > 0x7f)
      .length;
  // Letters must dominate — filters cost digits, footer fragments, art noise.
  if (letters < max(3, trimmed.length ~/ 2)) return null;
  final normalized = normalizeName(trimmed);
  return normalized.length >= 3 ? normalized : null;
}
