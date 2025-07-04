import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/service/database.dart';
import 'package:lorescanner/provider/cards_provider.dart';

/// Service responsible for centralizing all app initialization logic
class InitializationService {
  static final InitializationService _instance = InitializationService._internal();
  factory InitializationService() => _instance;
  InitializationService._internal();

  List<CameraDescription>? _cameras;
  List<Card>? _cards;
  bool _isInitialized = false;

  List<CameraDescription>? get cameras => _cameras;
  List<Card>? get cards => _cards;
  bool get isInitialized => _isInitialized;

  /// Initialize all app dependencies and services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize cameras
      await _initializeCameras();
      
      // Initialize database and fetch cards
      await _initializeDatabase();
      
      _isInitialized = true;
    } catch (e) {
      print('Error during initialization: $e');
      rethrow;
    }
  }

  /// Initialize cameras
  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras?.isEmpty ?? true) {
        throw Exception('No cameras found');
      }
    } catch (e) {
      print('Error initializing cameras: $e');
      rethrow;
    }
  }

  /// Initialize database and fetch cards
  Future<void> _initializeDatabase() async {
    try {
      _cards = await fetchCardsFromDB();
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  /// Initialize the CardsProvider with fetched cards
  void initializeCardsProvider(CardsProvider provider) {
    if (_cards != null) {
      provider.setCards(_cards!);
    }
  }

  /// Reset initialization state (useful for testing)
  void reset() {
    _cameras = null;
    _cards = null;
    _isInitialized = false;
  }
}