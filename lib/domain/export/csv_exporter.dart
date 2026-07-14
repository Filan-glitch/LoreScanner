import '../../data/repositories/card_repository.dart';

/// Dreamborn.ink CSV export — format ported from the legacy ExportService:
/// one row per variant, promoGrouping wins over setCode. The format has no
/// language column, so German and English copies of the same printing are
/// summed.
String toDreambornInk(List<CollectionCard> entries) {
  final buffer = StringBuffer();
  buffer.writeln('Set Number,Card Number,Variant,Count');

  final normal = <(String, int), int>{};
  final foil = <(String, int), int>{};
  final order = <(String, int)>[];
  for (final entry in entries) {
    if (!entry.isOwned) continue;
    final card = entry.card;
    final key = (card.promoGrouping ?? card.setCode, card.number);
    if (!normal.containsKey(key) && !foil.containsKey(key)) order.add(key);
    if (entry.amount > 0) {
      normal.update(key, (v) => v + entry.amount,
          ifAbsent: () => entry.amount);
    }
    if (entry.amountFoil > 0) {
      foil.update(key, (v) => v + entry.amountFoil,
          ifAbsent: () => entry.amountFoil);
    }
  }

  for (final key in order) {
    final set = _field(key.$1);
    final n = normal[key];
    final f = foil[key];
    if (n != null) buffer.writeln('$set,${key.$2},normal,$n');
    if (f != null) buffer.writeln('$set,${key.$2},foil,$f');
  }

  return buffer.toString();
}

/// Escapes a CSV field. Set segments come from the remote feed, so guard
/// against structure-breaking characters (RFC 4180 quoting) and leading
/// formula characters (spreadsheet injection). Plain values pass through
/// unchanged — the legacy export format stays byte-identical.
String _field(String value) {
  var v = value;
  if (v.startsWith('=') ||
      v.startsWith('+') ||
      v.startsWith('-') ||
      v.startsWith('@')) {
    v = "'$v";
  }
  if (v.contains(',') ||
      v.contains('"') ||
      v.contains('\n') ||
      v.contains('\r')) {
    v = '"${v.replaceAll('"', '""')}"';
  }
  return v;
}
