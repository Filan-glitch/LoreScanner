import 'package:lorescanner/models/collection.dart';

class ExportService {
  String toDreambornInk(Collection collection) {
    final buffer = StringBuffer();
    buffer.writeln('Set Number,Card Number,Variant,Count');

    for (final entry in collection.entries) {
      final card = entry.card;
      final foilCount = entry.amountFoil;
      final normalCount = entry.amount;

      if (normalCount > 0) {
        buffer.writeln(
            '${card.promoGrouping ?? card.setCode},${card.number},normal,$normalCount');
      }
      if (foilCount > 0) {
        buffer.writeln('${card.promoGrouping ?? card.setCode},${card.number},foil,$foilCount');
      }
    }

    return buffer.toString();
  }
}
