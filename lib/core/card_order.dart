/// Canonical ordering helpers for set codes and rarities.
library;

/// Numeric sets first in numeric order, letter-prefixed sets (Q1, Q2, …)
/// after, alphabetically.
int compareSetCodes(String a, String b) {
  final na = int.tryParse(a);
  final nb = int.tryParse(b);
  if (na != null && nb != null) return na.compareTo(nb);
  if (na != null) return -1;
  if (nb != null) return 1;
  return a.compareTo(b);
}

/// Canonical rarity order, both lorcanajson languages:
/// Common → Uncommon → Rare → Super Rare → Legendary → Epic → Enchanted →
/// Iconic → Special. (DE: Episch = Super Rare, Mythisch = Epic.)
const Map<String, int> _rarityRanks = {
  'Common': 0, 'Gewöhnlich': 0,
  'Uncommon': 1, 'Ungewöhnlich': 1,
  'Rare': 2, 'Selten': 2,
  'Super Rare': 3, 'Episch': 3,
  'Legendary': 4, 'Legendär': 4,
  'Epic': 5, 'Mythisch': 5,
  'Enchanted': 6, 'Verzaubert': 6,
  'Iconic': 7, 'Ikonisch': 7,
  'Special': 8, 'Speziell': 8,
};

int rarityRank(String rarity) => _rarityRanks[rarity] ?? 99;

int compareRarities(String a, String b) {
  final ranks = rarityRank(a).compareTo(rarityRank(b));
  return ranks != 0 ? ranks : a.compareTo(b);
}

/// Language-neutral ink keys. lorcanajson uses localized ink names
/// (DE: Bernstein, Smaragd, …) and hyphen-joined dual inks
/// ("Bernstein-Amethyst").
const Map<String, String> _inkKeys = {
  'Amber': 'amber', 'Bernstein': 'amber',
  'Amethyst': 'amethyst',
  'Emerald': 'emerald', 'Smaragd': 'emerald',
  'Ruby': 'ruby', 'Rubin': 'ruby',
  'Sapphire': 'sapphire', 'Saphir': 'sapphire',
  'Steel': 'steel', 'Stahl': 'steel',
};

/// Canonical ink keys for a raw ink value; splits hyphen-joined duals.
/// Unknown names are dropped.
Set<String> canonicalInks(String raw) => {
      for (final part in raw.split('-'))
        if (_inkKeys[part.trim()] != null) _inkKeys[part.trim()]!,
    };
