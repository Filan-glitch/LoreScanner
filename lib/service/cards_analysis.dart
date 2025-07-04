import 'dart:io';
import 'dart:ui' as ui;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/card.dart';

/// Parameters for image analysis that can be passed to an isolate
class ImageAnalysisParams {
  final String imagePath;
  final List<Card> cards;
  final ui.Rect? cropRegion;
  final bool enableProfiling;

  ImageAnalysisParams({
    required this.imagePath,
    required this.cards,
    this.cropRegion,
    this.enableProfiling = false,
  });
}

/// Results from image analysis including performance metrics
class ImageAnalysisResult {
  final Set<Card> foundCards;
  final String recognizedText;
  final Map<String, int> performanceMetrics;

  ImageAnalysisResult({
    required this.foundCards,
    required this.recognizedText,
    required this.performanceMetrics,
  });
}

/// Main entry point for image analysis - runs with improved performance
Future<ImageAnalysisResult> analyzeImage(File file, List<Card> cards, {ui.Rect? cropRegion}) async {
  final params = ImageAnalysisParams(
    imagePath: file.path,
    cards: cards,
    cropRegion: cropRegion,
    enableProfiling: true,
  );
  
  return await _analyzeImageInBackground(params);
}

/// Background image analysis function that can run in an isolate
Future<ImageAnalysisResult> _analyzeImageInBackground(ImageAnalysisParams params) async {
  final stopwatch = Stopwatch()..start();
  final metrics = <String, int>{};
  
  try {
    // Load and potentially crop the image
    final inputImage = await _prepareImage(params.imagePath, params.cropRegion);
    metrics['image_preparation_ms'] = stopwatch.elapsedMilliseconds;
    
    // Perform text recognition
    stopwatch.reset();
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    metrics['text_recognition_ms'] = stopwatch.elapsedMilliseconds;
    
    final String text = recognizedText.text;
    print('Recognized text: $text');
    
    // Find matching cards
    stopwatch.reset();
    final foundCards = _findMatchingCards(text, params.cards);
    metrics['card_matching_ms'] = stopwatch.elapsedMilliseconds;
    
    // Clean up
    textRecognizer.close();
    
    return ImageAnalysisResult(
      foundCards: foundCards,
      recognizedText: text,
      performanceMetrics: metrics,
    );
  } catch (e) {
    print('Error in image analysis: $e');
    return ImageAnalysisResult(
      foundCards: <Card>{},
      recognizedText: '',
      performanceMetrics: metrics,
    );
  }
}

/// Prepares the image for analysis, including cropping if specified
Future<InputImage> _prepareImage(String imagePath, ui.Rect? cropRegion) async {
  final file = File(imagePath);
  
  if (cropRegion == null) {
    // No cropping needed, use original image
    return InputImage.fromFile(file);
  }
  
  // For now, we'll use the original image since cropping requires more complex image processing
  // In a production app, you might want to use a package like 'image' for cropping
  // TODO: Implement actual image cropping based on cropRegion
  return InputImage.fromFile(file);
}

/// Finds cards that match the recognized text
Set<Card> _findMatchingCards(String text, List<Card> cards) {
  final lines = text.split('\n');
  
  // Find potential card names (uppercase lines longer than 1 character)
  final potentialNames = lines.where(
    (line) => line.isNotEmpty && line == line.toUpperCase() && line.length > 1,
  ).toList();
  
  // Also check for mixed case lines that might be card names
  potentialNames.addAll(lines.where(
    (line) => line.isNotEmpty && line.length > 3 && _isLikelyCardName(line),
  ));
  
  final foundCards = <Card>{};
  
  for (final potentialName in potentialNames) {
    final matches = cards.where((card) {
      final cardName = card.simpleName.toLowerCase();
      final searchName = potentialName.toLowerCase();
      
      // Exact match
      if (cardName == searchName) return true;
      
      // Partial match (card name contains search term or vice versa)
      if (cardName.contains(searchName) || searchName.contains(cardName)) {
        return true;
      }
      
      // Fuzzy match for common OCR errors
      if (_fuzzyMatch(cardName, searchName)) return true;
      
      return false;
    });
    
    foundCards.addAll(matches);
  }
  
  return foundCards;
}

/// Checks if a line is likely to be a card name based on patterns
bool _isLikelyCardName(String line) {
  // Card names typically have title case and reasonable length
  final words = line.split(' ');
  if (words.length > 6) return false; // Too many words
  
  // Check if it looks like a title (first letter capitalized)
  for (final word in words) {
    if (word.isNotEmpty && word[0].toUpperCase() == word[0]) {
      return true;
    }
  }
  
  return false;
}

/// Simple fuzzy matching for OCR errors
bool _fuzzyMatch(String cardName, String searchName) {
  // Simple Levenshtein distance-based matching
  if (cardName.length < 3 || searchName.length < 3) return false;
  
  final distance = _levenshteinDistance(cardName, searchName);
  final maxLength = cardName.length > searchName.length ? cardName.length : searchName.length;
  
  // Allow up to 20% character differences
  return distance <= (maxLength * 0.2);
}

/// Calculates Levenshtein distance between two strings
int _levenshteinDistance(String s1, String s2) {
  final len1 = s1.length;
  final len2 = s2.length;
  
  final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));
  
  for (int i = 0; i <= len1; i++) {
    matrix[i][0] = i;
  }
  
  for (int j = 0; j <= len2; j++) {
    matrix[0][j] = j;
  }
  
  for (int i = 1; i <= len1; i++) {
    for (int j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      matrix[i][j] = [
        matrix[i - 1][j] + 1,      // deletion
        matrix[i][j - 1] + 1,      // insertion
        matrix[i - 1][j - 1] + cost // substitution
      ].reduce((a, b) => a < b ? a : b);
    }
  }
  
  return matrix[len1][len2];
}