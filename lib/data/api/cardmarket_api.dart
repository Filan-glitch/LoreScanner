import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import 'dtos.dart';

class CardmarketApiException implements Exception {
  CardmarketApiException(this.statusCode);
  final int statusCode;

  /// Catalog rotation shows up as 403/404 on the old id.
  bool get looksLikeRotatedId => statusCode == 403 || statusCode == 404;

  @override
  String toString() => 'CardmarketApiException: HTTP $statusCode';
}

class CardmarketApi {
  CardmarketApi(this._client);

  final http.Client _client;

  /// Fetches the price guide for catalog [guideId].
  Future<List<PriceDto>> fetchPriceGuide(int guideId) async {
    final response = await _client.get(
        Uri.parse('$cardmarketPriceGuideBaseUrl/price_guide_$guideId.json'));
    if (response.statusCode != 200) {
      throw CardmarketApiException(response.statusCode);
    }
    final data =
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return [
      for (final raw in (data['priceGuides'] as List<dynamic>? ?? const []))
        PriceDtoMapper.fromMap(raw as Map<String, dynamic>),
    ];
  }
}
