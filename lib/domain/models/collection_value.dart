import '../../data/db/app_database.dart';
import '../../data/repositories/card_repository.dart';

/// Total collection value with price coverage ("Wert basiert auf X von Y
/// Karten"). Missing prices count as 0.
class CollectionValue {
  const CollectionValue({
    required this.total,
    required this.pricedCards,
    required this.ownedCards,
    this.fetchedAt,
  });

  final double total;

  /// Owned unique cards that had a usable price.
  final int pricedCards;

  /// Owned unique cards overall.
  final int ownedCards;

  /// Timestamp of the price cache ("Stand: …").
  final DateTime? fetchedAt;

  static CollectionValue compute(
    List<CollectionCard> entries,
    Map<int, Price> prices,
  ) {
    var total = 0.0;
    var priced = 0;
    var owned = 0;
    DateTime? fetchedAt;

    for (final entry in entries) {
      if (!entry.isOwned) continue;
      owned++;
      final cmId = entry.card.cardmarketId;
      final price = cmId == null ? null : prices[cmId];
      if (price == null) continue;
      final normal = price.avg ?? price.trend;
      final foil = price.avgFoil ?? price.trendFoil;
      var hadPrice = false;
      if (normal != null && entry.amount > 0) {
        total += entry.amount * normal;
        hadPrice = true;
      }
      if (foil != null && entry.amountFoil > 0) {
        total += entry.amountFoil * foil;
        hadPrice = true;
      }
      if (hadPrice) priced++;
      fetchedAt ??= DateTime.fromMillisecondsSinceEpoch(price.fetchedAt);
    }

    return CollectionValue(
      total: total,
      pricedCards: priced,
      ownedCards: owned,
      fetchedAt: fetchedAt,
    );
  }
}
