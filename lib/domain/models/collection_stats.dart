import '../../data/repositories/card_repository.dart';

/// Aggregate collection statistics, computed in Dart from the full joined
/// card list (~1.5k rows — cheap, stays reactive for free).
class CollectionStats {
  const CollectionStats({
    required this.ownedUnique,
    required this.totalCopies,
    required this.rarityCounts,
    required this.setCompletion,
  });

  /// Distinct owned printings.
  final int ownedUnique;

  /// Sum of all copies incl. foils.
  final int totalCopies;

  /// Owned unique cards per rarity.
  final Map<String, int> rarityCounts;

  /// setCode → (owned unique, total in set).
  final Map<String, ({int owned, int total})> setCompletion;

  static CollectionStats fromEntries(List<CollectionCard> entries) {
    var ownedUnique = 0;
    var totalCopies = 0;
    final rarityCounts = <String, int>{};
    final ownedPerSet = <String, int>{};
    final totalPerSet = <String, int>{};

    for (final entry in entries) {
      totalPerSet.update(entry.card.setCode, (v) => v + 1, ifAbsent: () => 1);
      if (!entry.isOwned) continue;
      ownedUnique++;
      totalCopies += entry.totalCopies;
      rarityCounts.update(entry.card.rarity, (v) => v + 1, ifAbsent: () => 1);
      ownedPerSet.update(entry.card.setCode, (v) => v + 1, ifAbsent: () => 1);
    }

    return CollectionStats(
      ownedUnique: ownedUnique,
      totalCopies: totalCopies,
      rarityCounts: rarityCounts,
      setCompletion: {
        for (final set in totalPerSet.keys)
          set: (owned: ownedPerSet[set] ?? 0, total: totalPerSet[set]!),
      },
    );
  }
}
