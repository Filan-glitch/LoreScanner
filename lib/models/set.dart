import 'package:dart_mappable/dart_mappable.dart';

part 'set.mapper.dart';

@MappableClass()
class Set with SetMappable{
  final int number;
  final String prereleaseDate;
  final String releaseDate;
  final bool hasAllCards;
  final String type;
  final String name;
  final String language;

  Set({
    required this.number,
    required this.prereleaseDate,
    required this.releaseDate,
    required this.hasAllCards,
    required this.type,
    required this.name,
    this.language = 'de'
  });
}