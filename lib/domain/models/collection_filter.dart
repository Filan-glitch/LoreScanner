import '../../data/db/app_database.dart';
import '../../data/repositories/card_repository.dart';

/// Immutable collection filter. Empty sets mean "no restriction".
class CollectionFilter {
  const CollectionFilter({
    this.sets = const {},
    this.inks = const {},
    this.rarities = const {},
    this.ownedOnly = true,
  });

  final Set<String> sets;
  final Set<String> inks;
  final Set<String> rarities;
  final bool ownedOnly;

  bool get isDefault =>
      sets.isEmpty && inks.isEmpty && rarities.isEmpty && ownedOnly;

  CollectionFilter copyWith({
    Set<String>? sets,
    Set<String>? inks,
    Set<String>? rarities,
    bool? ownedOnly,
  }) {
    return CollectionFilter(
      sets: sets ?? this.sets,
      inks: inks ?? this.inks,
      rarities: rarities ?? this.rarities,
      ownedOnly: ownedOnly ?? this.ownedOnly,
    );
  }

  bool matches(CollectionCard entry) {
    final Card card = entry.card;
    if (ownedOnly && !entry.isOwned) return false;
    if (sets.isNotEmpty && !sets.contains(card.setCode)) return false;
    if (rarities.isNotEmpty && !rarities.contains(card.rarity)) return false;
    if (inks.isNotEmpty) {
      // Dual-ink cards must appear under every one of their inks.
      final cardInks = _inksOf(card);
      if (!cardInks.any(inks.contains)) return false;
    }
    return true;
  }

  static List<String> _inksOf(Card card) {
    // Cheap containment check against the JSON text avoids decoding per row.
    return [
      for (final ink in knownInks)
        if (card.inksJson.contains('"$ink"')) ink,
    ];
  }
}

/// The six Lorcana inks.
const List<String> knownInks = [
  'Amber',
  'Amethyst',
  'Emerald',
  'Ruby',
  'Sapphire',
  'Steel',
];

/// Applies [filter] to the full joined list. Pure — unit-testable without
/// a database.
List<CollectionCard> applyFilter(
  List<CollectionCard> entries,
  CollectionFilter filter,
) =>
    [
      for (final entry in entries)
        if (filter.matches(entry)) entry,
    ];
