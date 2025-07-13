import 'package:lorescanner/models/collection.dart';

class ExportService {
  String toDreambornInk(Collection collection) {
    final buffer = StringBuffer();
    buffer.writeln('Set Number,Card Number,Variant,Count');

    for (final entry in collection.entries) {
      final card = entry.card;
      final foilCount = entry.foilCount;
      final normalCount = entry.normalCount;

      if (normalCount > 0) {
        buffer.writeln(
            '${card.setNum},${card.cardNum},normal,$normalCount');
      }
      if (foilCount > 0) {
        buffer.writeln('${card.setNum},${card.cardNum},foil,$foilCount');
      }
    }

    return buffer.toString();
  }
}
