import 'dart:convert';

import '../../data/db/app_database.dart';

/// Decoded views over the JSON text columns of a Drift [Card] row.
extension CardJsonFields on Card {
  Map<String, String> get images =>
      (jsonDecode(imagesJson) as Map<String, dynamic>).cast<String, String>();

  Map<String, String> get externalLinks =>
      (jsonDecode(externalLinksJson) as Map<String, dynamic>)
          .cast<String, String>();

  List<String> get inks =>
      (jsonDecode(inksJson) as List<dynamic>).cast<String>();

  List<String> get foilTypes =>
      (jsonDecode(foilTypesJson) as List<dynamic>).cast<String>();

  String? get thumbnailUrl => images['thumbnail'] ?? images['full'];

  String? get fullImageUrl => images['full'] ?? images['thumbnail'];
}
