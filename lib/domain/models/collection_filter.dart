import '../../core/card_order.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/card_repository.dart';
import 'card_ext.dart';

/// Immutable collection filter. Empty sets mean "no restriction".
class CollectionFilter {
  const CollectionFilter({
    this.sets = const {},
    this.inks = const {},
    this.rarities = const {},
    this.languages = const {},
    this.ownedOnly = true,
  });

  final Set<String> sets;
  final Set<String> inks;

  /// Rarity chips are German labels; matching goes through [rarityRank] so
  /// English cards (English rarity strings) match the same chip.
  final Set<String> rarities;

  /// Card languages ('de'/'en').
  final Set<String> languages;
  final bool ownedOnly;

  bool get isDefault =>
      sets.isEmpty &&
      inks.isEmpty &&
      rarities.isEmpty &&
      languages.isEmpty &&
      ownedOnly;

  CollectionFilter copyWith({
    Set<String>? sets,
    Set<String>? inks,
    Set<String>? rarities,
    Set<String>? languages,
    bool? ownedOnly,
  }) {
    return CollectionFilter(
      sets: sets ?? this.sets,
      inks: inks ?? this.inks,
      rarities: rarities ?? this.rarities,
      languages: languages ?? this.languages,
      ownedOnly: ownedOnly ?? this.ownedOnly,
    );
  }

  bool matches(CollectionCard entry) {
    final Card card = entry.card;
    if (ownedOnly && !entry.isOwned) return false;
    if (languages.isNotEmpty && !languages.contains(card.language)) {
      return false;
    }
    if (sets.isNotEmpty && !sets.contains(card.setCode)) return false;
    if (rarities.isNotEmpty &&
        !rarities.map(rarityRank).contains(rarityRank(card.rarity))) {
      return false;
    }
    if (inks.isNotEmpty) {
      // Dual-ink cards must appear under every one of their inks; matching
      // is language-neutral via canonical ink keys.
      final wanted = {for (final ink in inks) ...canonicalInks(ink)};
      final cardInks = _inksOf(card);
      if (!cardInks.any(wanted.contains)) return false;
    }
    return true;
  }

  // Caches the decoded ink set per Card row — applyFilter runs over the
  // full joined list (~6k rows) on every filter change, and jsonDecode per
  // row per pass is the hot-path cost. Card rows are recreated per stream
  // emission, so stale entries fall away with their keys.
  static final Expando<Set<String>> _inkCache = Expando();

  static Set<String> _inksOf(Card card) =>
      _inkCache[card] ??= _computeInks(card);

  static Set<String> _computeInks(Card card) {
    // The inks list is authoritative (it always contains the primary ink);
    // the ink column is only a fallback for rows without a list.
    final list = card.inks;
    if (list.isNotEmpty) {
      return {for (final ink in list) ...canonicalInks(ink)};
    }
    return canonicalInks(card.ink);
  }
}

/// The six Lorcana inks — German labels (the app UI is German).
const List<String> knownInks = [
  'Bernstein',
  'Amethyst',
  'Smaragd',
  'Rubin',
  'Saphir',
  'Stahl',
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
