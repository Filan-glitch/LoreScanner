import '../../data/repositories/card_repository.dart';

/// Aggregate collection statistics, computed in Dart from the full joined
/// card list (both languages; ~6k rows — cheap, stays reactive for free).
class CollectionStats {
  const CollectionStats({
    required this.ownedUnique,
    required this.totalCopies,
    required this.rarityCounts,
    required this.setCompletion,
  });

  /// Distinct owned printings — a German and an English copy of the same
  /// card count as two entries (physically different cards).
  final int ownedUnique;

  /// Sum of all copies incl. foils.
  final int totalCopies;

  /// Owned entries per rarity, keyed by each row's own (per-language)
  /// rarity label.
  final Map<String, int> rarityCounts;

  /// setCode → (owned unique ids, total ids in set). Language-agnostic: a
  /// card counts as owned no matter which language you have it in, and the
  /// set size counts each id once.
  final Map<String, ({int owned, int total})> setCompletion;

  static CollectionStats fromEntries(List<CollectionCard> entries) {
    var ownedUnique = 0;
    var totalCopies = 0;
    final rarityCounts = <String, int>{};
    final idsPerSet = <String, Set<int>>{};
    final ownedIdsPerSet = <String, Set<int>>{};

    for (final entry in entries) {
      final card = entry.card;
      idsPerSet.putIfAbsent(card.setCode, () => {}).add(card.id);
      if (!entry.isOwned) continue;
      ownedUnique++;
      totalCopies += entry.totalCopies;
      // Rarity labels differ per language — each entry counts under its
      // own row's label ('Gewöhnlich' and 'Common' are separate buckets).
      // A UI consuming this map must normalize via rarityRank first.
      rarityCounts.update(card.rarity, (v) => v + 1, ifAbsent: () => 1);
      ownedIdsPerSet.putIfAbsent(card.setCode, () => {}).add(card.id);
    }

    return CollectionStats(
      ownedUnique: ownedUnique,
      totalCopies: totalCopies,
      rarityCounts: rarityCounts,
      setCompletion: {
        for (final set in idsPerSet.keys)
          set: (
            owned: ownedIdsPerSet[set]?.length ?? 0,
            total: idsPerSet[set]!.length,
          ),
      },
    );
  }
}
