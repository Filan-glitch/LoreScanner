import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import 'dtos.dart';

class LorcanaApiException implements Exception {
  LorcanaApiException(this.message);
  final String message;

  @override
  String toString() => 'LorcanaApiException: $message';
}

/// lorcanajson.org client. Injected [http.Client] for testability.
class LorcanaApi {
  LorcanaApi(this._client);

  final http.Client _client;

  /// Fetches only the small metadata file — cheap freshness probe.
  Future<MetadataDto> fetchMetadata(String language) async {
    final response = await _client
        .get(Uri.parse('$lorcanaJsonBaseUrl/$language/metadata.json'));
    if (response.statusCode != 200) {
      throw LorcanaApiException(
          'metadata.json HTTP ${response.statusCode} for $language');
    }
    return MetadataDtoMapper.fromMap(
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  }

  /// Fetches the full card list plus its embedded metadata.
  Future<({MetadataDto metadata, List<CardDto> cards})> fetchAllCards(
    String language,
  ) async {
    final response = await _client
        .get(Uri.parse('$lorcanaJsonBaseUrl/$language/allCards.json'));
    if (response.statusCode != 200) {
      throw LorcanaApiException(
          'allCards.json HTTP ${response.statusCode} for $language');
    }
    final data =
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final metadata = MetadataDtoMapper.fromMap(
        (data['metadata'] as Map<String, dynamic>?) ??
            {
              'formatVersion': 'unknown',
              'generatedOn': 'unknown',
              'language': language,
            });
    final cards = [
      for (final raw in (data['cards'] as List<dynamic>? ?? const []))
        CardDtoMapper.fromMap(raw as Map<String, dynamic>),
    ];
    return (metadata: metadata, cards: cards);
  }
}
