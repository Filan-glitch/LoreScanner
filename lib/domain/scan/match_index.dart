import '../../data/db/app_database.dart';

/// One indexed card. Plain data — cheap to send across an isolate boundary.
class IndexEntry {
  const IndexEntry({
    required this.cardId,
    required this.searchName,
    required this.setCode,
    required this.number,
    this.promoGrouping,
  });

  final int cardId;
  final String searchName;
  final String setCode;
  final int number;
  final String? promoGrouping;
}

/// Pre-bucketed card index: first letter + length band cut ~1.5k canidates
/// down to tens per lookup.
class MatchIndex {
  MatchIndex._(this.entries, this._byFirstLetter, this._byNumber);

  final List<IndexEntry> entries;
  final Map<String, List<IndexEntry>> _byFirstLetter;
  final Map<int, List<IndexEntry>> _byNumber;

  factory MatchIndex.build(List<IndexEntry> entries) {
    final byLetter = <String, List<IndexEntry>>{};
    final byNumber = <int, List<IndexEntry>>{};
    for (final entry in entries) {
      if (entry.searchName.isNotEmpty) {
        byLetter.putIfAbsent(entry.searchName[0], () => []).add(entry);
      }
      byNumber.putIfAbsent(entry.number, () => []).add(entry);
    }
    return MatchIndex._(entries, byLetter, byNumber);
  }

  factory MatchIndex.fromCards(List<Card> cards) => MatchIndex.build([
        for (final card in cards)
          IndexEntry(
            cardId: card.id,
            searchName: card.searchName,
            setCode: card.setCode,
            number: card.number,
            promoGrouping: card.promoGrouping,
          ),
      ]);

  /// Name-match candidates: same first letter, length within ±25%.
  List<IndexEntry> candidatesFor(String normalizedName) {
    if (normalizedName.isEmpty) return const [];
    final bucket = _byFirstLetter[normalizedName[0]] ?? const [];
    final len = normalizedName.length;
    final minLen = (len * 0.75).floor();
    final maxLen = (len * 1.25).ceil();
    return [
      for (final entry in bucket)
        if (entry.searchName.length >= minLen &&
            entry.searchName.length <= maxLen)
          entry,
    ];
  }

  /// Footer lookup: (number, setCode?, promo total segment). The total
  /// segment separates promos (`P1`…) from same-numbered regular cards.
  IndexEntry? byFooter(int number, {String? setCode, String? totalSegment}) {
    final candidates = _byNumber[number] ?? const [];
    final isPromo = totalSegment != null && totalSegment.startsWith('P');
    final filtered = [
      for (final entry in candidates)
        if ((setCode == null || entry.setCode == setCode) &&
            (totalSegment == null ||
                (isPromo
                    ? entry.promoGrouping == totalSegment
                    : entry.promoGrouping == null)))
          entry,
    ];
    return filtered.length == 1 ? filtered.first : null;
  }
}
