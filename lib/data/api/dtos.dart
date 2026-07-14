import 'package:dart_mappable/dart_mappable.dart';

part 'dtos.mapper.dart';

/// lorcanajson file metadata — `generatedOn` drives the sync decision.
@MappableClass()
class MetadataDto with MetadataDtoMappable {
  final String formatVersion;
  final String generatedOn;
  final String language;

  MetadataDto({
    required this.formatVersion,
    required this.generatedOn,
    required this.language,
  });
}

/// Raw card from lorcanajson `allCards.json`. Defaults are deliberately
/// lenient — a missing optional field must not sink the whole sync.
@MappableClass()
class CardDto with CardDtoMappable {
  final int id;
  final String setCode;
  final int number;
  final String simpleName;
  final String fullName;
  final String rarity;
  final String type;
  final String story;
  final int cost;
  final bool inkwell;
  final String? color;
  final List<String>? colors;
  final String? promoGrouping;
  final List<String> foilTypes;
  final Map<String, String> images;
  final Map<String, String> externalLinks;

  CardDto({
    required this.id,
    required this.setCode,
    required this.number,
    required this.simpleName,
    required this.fullName,
    this.rarity = '',
    this.type = '',
    this.story = '',
    this.cost = 0,
    this.inkwell = false,
    this.color,
    this.colors,
    this.promoGrouping,
    this.foilTypes = const [],
    this.images = const {},
    this.externalLinks = const {},
  });

  /// Primary ink: `color` when set, else first of `colors`. Dual-ink cards
  /// carry hyphen-joined values ("Bernstein-Amethyst") — first part wins.
  String get primaryInk {
    if (color != null && color!.isNotEmpty) return color!.split('-').first;
    if (colors != null && colors!.isNotEmpty) return colors!.first;
    return '';
  }

  /// Full ink list for filter matching — splits hyphen-joined duals.
  List<String> get inks {
    if (colors != null && colors!.isNotEmpty) return colors!;
    if (color != null && color!.isNotEmpty) return color!.split('-');
    return const [];
  }

  int? get cardmarketId => int.tryParse(externalLinks['cardmarketId'] ?? '');
}

/// Cardmarket price guide row.
@MappableClass()
class PriceDto with PriceDtoMappable {
  final int idProduct;
  final double? avg;
  final double? low;
  final double? trend;
  final double? avg1;
  final double? avg7;
  final double? avg30;

  @MappableField(key: 'avg-foil')
  final double? avgFoil;

  @MappableField(key: 'low-foil')
  final double? lowFoil;

  @MappableField(key: 'trend-foil')
  final double? trendFoil;

  @MappableField(key: 'avg1-foil')
  final double? avg1Foil;

  @MappableField(key: 'avg7-foil')
  final double? avg7Foil;

  @MappableField(key: 'avg30-foil')
  final double? avg30Foil;

  PriceDto({
    required this.idProduct,
    this.avg,
    this.low,
    this.trend,
    this.avg1,
    this.avg7,
    this.avg30,
    this.avgFoil,
    this.lowFoil,
    this.trendFoil,
    this.avg1Foil,
    this.avg7Foil,
    this.avg30Foil,
  });
}
