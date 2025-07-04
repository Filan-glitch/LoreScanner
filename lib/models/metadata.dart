import 'package:dart_mappable/dart_mappable.dart';

part 'metadata.mapper.dart';

@MappableClass()
class Metadata with MetadataMappable {
  final String formatVersion;
  final String generatedOn;
  final String language;

  Metadata({
    required this.formatVersion,
    required this.generatedOn,
    required this.language,
  });
}