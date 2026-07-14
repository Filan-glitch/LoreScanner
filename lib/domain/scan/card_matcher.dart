import '../../core/constants.dart';
import 'match_index.dart';
import 'ocr_parser.dart';

/// Input for one matching pass — plain data, safe for `compute()`.
class MatchInput {
  const MatchInput({required this.parsed, required this.index});

  final ParsedOcr parsed;
  final MatchIndex index;
}

class MatchResult {
  const MatchResult({required this.cardId, required this.score});

  final int cardId;
  final double score;
}

/// Scores OCR output against the index. Pure; runs inside `compute()`.
///
/// Returns null when nothing clears [matchConfidenceThreshold] or the top
/// two candidates are within [matchAmbiguityWindow] (ambiguous — better no
/// match than a wrong auto-add).
MatchResult? matchCards(MatchInput input) {
  final parsed = input.parsed;
  final index = input.index;
  final scores = <int, double>{};

  for (final candidate in parsed.nameCandidates) {
    for (final entry in index.candidatesFor(candidate)) {
      final score = _nameScore(candidate, entry.searchName);
      if (score <= 0) continue;
      final fused = _fuseFooter(score, entry, parsed.footer);
      scores.update(entry.cardId, (v) => v > fused ? v : fused,
          ifAbsent: () => fused);
    }
  }

  // Footer-only identification. OCR misreads digits, so a footer hit may
  // only override the name path when no name was read at all or the footer
  // card's name is at least plausible against a read candidate — otherwise
  // a mangled "36/204" silently maps to a completely different card.
  final footer = parsed.footer;
  if (footer != null) {
    final entry = index.byFooter(
      footer.number,
      setCode: footer.setCode,
      totalSegment: footer.totalSegment,
    );
    if (entry != null) {
      final namePlausible = parsed.nameCandidates.isEmpty ||
          parsed.nameCandidates
              .any((c) => _nameScore(c, entry.searchName) >= 0.5);
      if (namePlausible) {
        scores.update(entry.cardId, (v) => v > 0.9 ? v : 0.9,
            ifAbsent: () => 0.9);
      }
    }
  }

  if (scores.isEmpty) return null;
  final ranked = scores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final best = ranked.first;
  if (best.value < matchConfidenceThreshold) return null;
  if (ranked.length > 1 &&
      best.value - ranked[1].value < matchAmbiguityWindow) {
    return null;
  }
  return MatchResult(cardId: best.key, score: best.value);
}

double _nameScore(String candidate, String searchName) {
  if (candidate == searchName) return 1.0;
  if (searchName.contains(candidate) || candidate.contains(searchName)) {
    final ratio = candidate.length < searchName.length
        ? candidate.length / searchName.length
        : searchName.length / candidate.length;
    if (ratio >= 0.5) return 0.85 * ratio + 0.1;
  }
  final maxLen =
      candidate.length > searchName.length ? candidate.length : searchName.length;
  final limit = (maxLen * 0.3).floor();
  final distance = _boundedLevenshtein(candidate, searchName, limit);
  if (distance < 0) return 0;
  return 1.0 - distance / maxLen;
}

/// Footer agreement pins the exact printing (+0.2); disagreement on set or
/// promo segment is evidence against.
double _fuseFooter(double score, IndexEntry entry, FooterInfo? footer) {
  if (footer == null) return score;
  final numberMatches = entry.number == footer.number;
  final setMatches = footer.setCode == null || entry.setCode == footer.setCode;
  // The total segment separates promos from same-numbered regular prints:
  // 20/P1 must hit the promoGrouping=P1 card, 20/204 the regular one.
  final promoMatches = footer.isPromo
      ? entry.promoGrouping == footer.totalSegment
      : entry.promoGrouping == null;
  if (numberMatches && setMatches && promoMatches) {
    return (score + 0.2).clamp(0.0, 1.0);
  }
  if ((footer.setCode != null && !setMatches) ||
      (numberMatches && !promoMatches)) {
    return score - 0.1;
  }
  return score;
}

/// Levenshtein with early bail-out: returns -1 once the distance must
/// exceed [limit]. Two rolling rows instead of a full matrix.
int _boundedLevenshtein(String a, String b, int limit) {
  if ((a.length - b.length).abs() > limit) return -1;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  var curr = List<int>.filled(b.length + 1, 0);

  for (var i = 1; i <= a.length; i++) {
    curr[0] = i;
    var rowMin = curr[0];
    for (var j = 1; j <= b.length; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      curr[j] = [
        curr[j - 1] + 1,
        prev[j] + 1,
        prev[j - 1] + cost,
      ].reduce((x, y) => x < y ? x : y);
      if (curr[j] < rowMin) rowMin = curr[j];
    }
    if (rowMin > limit) return -1;
    final tmp = prev;
    prev = curr;
    curr = tmp;
  }
  return prev[b.length] <= limit ? prev[b.length] : -1;
}
