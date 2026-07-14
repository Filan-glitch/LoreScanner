import '../../data/repositories/card_repository.dart';

/// Dreamborn.ink CSV export — logic ported verbatim from the legacy
/// ExportService: one row per variant, promoGrouping wins over setCode.
String toDreambornInk(List<CollectionCard> entries) {
  final buffer = StringBuffer();
  buffer.writeln('Set Number,Card Number,Variant,Count');

  for (final entry in entries) {
    if (!entry.isOwned) continue;
    final card = entry.card;
    final setSegment = card.promoGrouping ?? card.setCode;
    if (entry.amount > 0) {
      buffer.writeln('$setSegment,${card.number},normal,${entry.amount}');
    }
    if (entry.amountFoil > 0) {
      buffer.writeln('$setSegment,${card.number},foil,${entry.amountFoil}');
    }
  }

  return buffer.toString();
}
