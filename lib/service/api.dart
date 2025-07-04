// function to get the json file from the api with url 'https://www.lorcanajson.org/files/current/de/allCards.json'
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lorescanner/models/card.dart';

Future<List<Card>> fetchCards(String language) async {
  final response = await http.get(Uri.parse('https://www.lorcanajson.org/files/current/$language/allCards.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final Map<String, dynamic> metaData = jsonData['metadata'] ?? {};
    final String lang = metaData['language'] ?? language;
    final List<dynamic> cardsData = jsonData['cards'];
    final List<Card> cards = cardsData.map((card) {
      // Inject language from metadata if not present
      if (!card.containsKey('language')) {
        card = Map<String, dynamic>.from(card);
        card['language'] = lang;
      }
      return CardMapper.fromMap(card);
    }).toList();
    return cards;
  } else {
    throw Exception('Failed to load cards');
  }
}