import 'package:dart_mappable/dart_mappable.dart';

part 'price.mapper.dart';

@MappableClass()
class Price with PriceMappable {
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

  Price({
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

  List<MapEntry<String, dynamic>> get attributes {
    return [
      MapEntry('Durchschnitt', avg),
      MapEntry('Niedrigster', low),
      MapEntry('Trend', trend),
      MapEntry('Durchschnitt 1 Tag', avg1),
      MapEntry('Durchschnitt 7 Tage', avg7),
      MapEntry('Durchschnitt 30 Tage', avg30),
      MapEntry('Durchschnitt (Foil)', avgFoil),
      MapEntry('Niedrigster (Foil)', lowFoil),
      MapEntry('Trend (Foil)', trendFoil),
      MapEntry('Durchschnitt 1 Tag (Foil)', avg1Foil),
      MapEntry('Durchschnitt 7 Tage (Foil)', avg7Foil),
      MapEntry('Durchschnitt 30 Tage (Foil)', avg30Foil),
    ];
  }
}