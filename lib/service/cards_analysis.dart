import 'dart:io';
import 'dart:ui' as ui;

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../models/card.dart';
import '../models/card_match.dart';

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
  final List<CardMatch> foundCards;
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
      foundCards: [],
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
  
  try {
    // Read the original image
    final bytes = await file.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    
    if (originalImage == null) {
      print('Could not decode image for cropping, using original');
      return InputImage.fromFile(file);
    }
    
    // Calculate crop boundaries based on the ROI region
    // Note: cropRegion is in screen coordinates, we need to map to image coordinates
    final imageWidth = originalImage.width;
    final imageHeight = originalImage.height;
    
    // For now, use a simple mapping assuming the ROI is centered
    // In a production app, you'd want to consider the actual camera preview scaling
    final cropX = (cropRegion.left * imageWidth / 375).round().clamp(0, imageWidth);
    final cropY = (cropRegion.top * imageHeight / 667).round().clamp(0, imageHeight);
    final cropWidth = (cropRegion.width * imageWidth / 375).round().clamp(0, imageWidth - cropX);
    final cropHeight = (cropRegion.height * imageHeight / 667).round().clamp(0, imageHeight - cropY);
    
    // Crop the image
    final croppedImage = img.copyCrop(
      originalImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );
    
    // Save the cropped image to a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(tempDir.path, 'cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final croppedFile = File(tempPath);
    
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
    
    print('Image cropped from ${imageWidth}x${imageHeight} to ${cropWidth}x${cropHeight}');
    
    return InputImage.fromFile(croppedFile);
  } catch (e) {
    print('Error cropping image: $e, using original');
    return InputImage.fromFile(file);
  }
}

/// Finds cards that match the recognized text and scores them
List<CardMatch> _findMatchingCards(String text, List<Card> cards) {
  final lines = text.split('\n');

  // Find potential card names
  final potentialNames = lines
      .where((line) =>
          (line.isNotEmpty &&
              line == line.toUpperCase() &&
              line.length > 1) ||
          (line.isNotEmpty && line.length > 3 && _isLikelyCardName(line)))
      .toSet(); // Use a Set to avoid duplicate names

  final foundCards = <CardMatch>[];
  final matchedCardIds = <String>{}; // Track matched card IDs to avoid duplicates

  for (final potentialName in potentialNames) {
    for (final card in cards) {
      if (matchedCardIds.contains(card.id)) continue; // Skip if already matched

      final cardName = card.simpleName.toLowerCase();
      final searchName = potentialName.toLowerCase();
      double score = 0;

      // Exact match
      if (cardName == searchName) {
        score = 1.0;
      }
      // Partial match
      else if (cardName.contains(searchName) ||
          searchName.contains(cardName)) {
        final double lenScore = searchName.length / cardName.length;
        score = 0.8 * lenScore; // Base score for partial match, adjusted by length
      }
      // Fuzzy match
      else if (_fuzzyMatch(cardName, searchName)) {
        final distance = _levenshteinDistance(cardName, searchName);
        final maxLength = cardName.length > searchName.length
            ? cardName.length
            : searchName.length;
        score = 0.6 * (1 - (distance / maxLength)); // Base score for fuzzy
      }

      if (score > 0) {
        foundCards.add(CardMatch(card: card, score: score));
        matchedCardIds.add(card.id);
      }
    }
  }

  // Sort by score descending
  foundCards.sort((a, b) => b.score.compareTo(a.score));

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