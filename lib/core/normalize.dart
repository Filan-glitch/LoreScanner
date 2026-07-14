/// Shared name normalization. MUST be the single source of truth for both
/// sync-time `search_name` writes and OCR candidate normalization in the
/// scanner — any drift between the two breaks matching.
library;

const Map<String, String> _replacements = {
  'ä': 'ae',
  'ö': 'oe',
  'ü': 'ue',
  'ß': 'ss',
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'å': 'a',
  'æ': 'ae',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'ø': 'o',
  'œ': 'oe',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ç': 'c',
  'ñ': 'n',
};

/// Lowercases, folds German umlauts/accents, strips everything that is not
/// `[a-z0-9 ]`, and collapses whitespace.
String normalizeName(String input) {
  final buffer = StringBuffer();
  for (final rune in input.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    final replaced = _replacements[char] ?? char;
    for (final c in replaced.runes) {
      if ((c >= 0x61 && c <= 0x7a) || (c >= 0x30 && c <= 0x39) || c == 0x20) {
        buffer.writeCharCode(c);
      }
    }
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}
