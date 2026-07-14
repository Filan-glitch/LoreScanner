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

/// The footer identifier sits in the bottom band. Card names sit mid-card
/// on Lorcana (below the artwork), so everything above the footer band is a
/// potential name line — the candidate filter and ALL-CAPS priority sort
/// out ability/flavor noise.
const double _footerBandFraction = 0.18;

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
  final footerBandTop = roi.bottom - roi.height * _footerBandFraction;

  // (candidate, isAllCaps) — Lorcana prints the card name in capitals, so
  // ALL-CAPS lines outrank mixed-case ability/flavor text.
  final names = <(String, bool)>[];
  FooterInfo? footer;

  for (final line in lines) {
    final center = line.boundingBox.center;
    if (!roi.contains(center)) continue;

    if (center.dy >= footerBandTop) {
      footer ??= parseFooterLine(line.text);
      continue;
    }

    final candidate = _nameCandidate(line.text);
    if (candidate != null) {
      names.add((candidate, line.text == line.text.toUpperCase()));
    }
  }

  names.sort((a, b) {
    if (a.$2 != b.$2) return a.$2 ? -1 : 1;
    return b.$1.length.compareTo(a.$1.length);
  });
  return ParsedOcr(
    nameCandidates: [for (final n in names.take(5)) n.$1],
    footer: footer,
  );
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
