import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart';

import '../models/card.dart';

Future<Set<Card>> analyzeImage(File file, List<Card> cards) async {
  final inputImage = InputImage.fromFile(file);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText =
  await textRecognizer.processImage(inputImage);
  String text = recognizedText.text;
  print('Recognized text: $text');

  // Find Cards
  final lines = text.split('\n');
  // find first line that is completly uppercase and longer than one symbol, which is likely the card's name
  final name = lines.firstWhere(
    (line) => line.isNotEmpty && line == line.toUpperCase() && line.length > 1,
    orElse: () => '',
  );

  final matches = cards.where((card) {
    // Check if any line contains the card's simpleName (case-insensitive)
    return card.simpleName.contains(name.toLowerCase());
  });

  textRecognizer.close();
  return matches.toSet();
}