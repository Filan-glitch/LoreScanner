import 'package:camera/camera.dart';
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/models/collection.dart';
import 'package:lorescanner/models/price.dart';
import 'package:lorescanner/service/database.dart';
import 'package:lorescanner/provider/cards_provider.dart';

import 'api.dart';

/// Service responsible for centralizing all app initialization logic
class InitializationService {
  static final InitializationService _instance = InitializationService._internal();
  factory InitializationService() => _instance;
  InitializationService._internal();

  List<CameraDescription>? _cameras;
  List<Card>? _cards;
  Collection? _collection;
  List<Price>? _prices;
  bool _isInitialized = false;

  List<CameraDescription>? get cameras => _cameras;
  List<Card>? get cards => _cards;
  Collection? get collection => _collection;
  List<Price>? get prices => _prices;
  bool get isInitialized => _isInitialized;

  /// Initialize all app dependencies and services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize cameras
      await _initializeCameras();
      
      // Initialize database and fetch cards
      await _initializeDatabase();
      
      // Initialize collection data
      await _initializeCollection();

      // Initialize prices
      await initializePrices();
      
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

  /// Initialize collection data
  Future<void> _initializeCollection() async {
    try {
      final collectionData = await fetchCollectionFromDB();
      final List<CollectionEntry> entries = [];
      
      if (_cards != null) {
        for (final card in _cards!) {
          if (collectionData.containsKey(card.id)) {
            final data = collectionData[card.id]!;
            entries.add(CollectionEntry(
              card: card,
              amount: data['amount']!,
              amountFoil: data['amountFoil']!,
            ));
          }
        }
      }
      
      _collection = Collection(entries: entries);
    } catch (e) {
      print('Error initializing collection: $e');
      rethrow;
    }
  }

  /// Initialize prices
  Future<void> initializePrices() async {
    try {
      _prices = await fetchPrices();
    } catch (e) {
      print('Error initializing prices: $e');
      rethrow;
    }
  }

  /// Initialize the CardsProvider with fetched cards and collection
  void initializeCardsProvider(CardsProvider provider) {
    if (_cards != null) {
      provider.setCards(_cards!);
    }
    if (_collection != null) {
      provider.setCollection(_collection!);
    }
    if (_prices != null) {
      provider.setPrices(_prices!);
    }
  }

  /// Reset initialization state (useful for testing)
  void reset() {
    _cameras = null;
    _cards = null;
    _collection = null;
    _prices = null;
    _isInitialized = false;
  }
}