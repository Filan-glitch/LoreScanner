import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/provider/tab_notifier.dart';
import 'package:lorescanner/service/logging.dart';
import 'package:lorescanner/widgets/found_cards_overview.dart';
import 'package:lorescanner/widgets/card_template_overlay.dart';
import 'package:lorescanner/service/initialization_service.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';

import '../service/cards_analysis.dart';

class ScannerScreen extends StatefulWidget {
  final TabNotifier tabNotifier;
  const ScannerScreen({super.key, required this.tabNotifier});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool loading = false;
  final InitializationService _initService = InitializationService();

  // Performance tracking
  final List<String> _performanceLogs = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if(_cameraController == null || !_cameraController!.value.isInitialized) {
      _initializeCameraController();
    }
    widget.tabNotifier.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.tabNotifier.removeListener(_handleTabChange);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.tabNotifier.value == 0) {
      _initializeCameraController();
    } else {
      // Dispose camera controller when leaving the scanner tab
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        _cameraController!.dispose();
      }
    }
  }

  Future<void> _initializeCameraController() async {
    // Get cameras from the centralized initialization service
    final cameras = _initService.cameras;
    if (cameras == null || cameras.isEmpty) {
      log.severe('No cameras available from initialization service');
      return;
    }

    // Use medium resolution for better performance while maintaining quality
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium, // Changed from max to medium for better performance
    );

    _cameraController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_cameraController!.value.hasError) {
        log.severe('Camera error: ${_cameraController!.value.errorDescription}');
      }
    });

    try {
      await _cameraController!.initialize();
    } catch (e, st) {
      log.severe('Error initializing camera controller', e, st);
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  Future<XFile?> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      log.severe('Error: Camera is not initialized');
      return null;
    }
    try {
      final image = await _cameraController!.takePicture();
      log.info('Picture taken: ${image.path}');
      return image;
    } catch (e, st) {
      log.severe('Error taking picture', e, st);
    }
    return null;
  }

  /// Analyzes the image in the background using compute()
  Future<ImageAnalysisResult> _analyzeImageInBackground(File imageFile, List<Card> cards) async {
    final screenSize = MediaQuery.of(context).size;
    final cardBounds = CardTemplateOverlayExtension.getCardBounds(screenSize);
    
    // For now, run analysis on main thread but with improved logic
    // In a production app, you'd want to implement proper isolate communication
    return await analyzeImage(imageFile, cards, cropRegion: cardBounds);
  }

  /// Shows performance metrics in a dialog
  void _showPerformanceDialog(Map<String, int> metrics) {
    if (!kDebugMode) return; // Only show in debug mode
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Metrics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...metrics.entries.map((entry) => 
              Text('${entry.key}: ${entry.value}ms')),
            const SizedBox(height: 10),
            Text('Total: ${metrics.values.fold(0, (a, b) => a + b)}ms'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    
    // Check if everything is properly initialized
    if (_cameraController == null || !_cameraController!.value.isInitialized || cardsProvider.cards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan eine Karte...'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Performance Logs'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _performanceLogs.length,
                        itemBuilder: (context, index) => Text(_performanceLogs[index]),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: loading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.camera_alt),
        onPressed: loading ? null : () async {
          setState(() {
            loading = true;
          });
          
          final overallStopwatch = Stopwatch()..start();
          
          try {
            // Take picture
            final image = await _takePicture();
            if (image != null) {
              // Analyze image in background
              final result = await _analyzeImageInBackground(
                File(image.path), 
                cardsProvider.cards
              );
              
              overallStopwatch.stop();
              
              // Log performance
              final totalTime = overallStopwatch.elapsedMilliseconds;
              final logEntry = 'Scan completed in ${totalTime}ms - Found ${result.foundCards.length} cards';
              _performanceLogs.add(logEntry);
              log.info(logEntry);
              
              // Show performance metrics in debug mode
              if (kDebugMode) {
                _showPerformanceDialog(result.performanceMetrics);
              }
              
              log.info('Found cards: ${result.foundCards.length}');
              
              if (result.foundCards.isNotEmpty) {
                final Map<String, dynamic>? map = await showDialog(
                  context: context,
                  builder: (context) => FoundCardsOverview(foundCards: result.foundCards),
                );
                
                if (map != null) {
                  final Card card = map['card'];
                  final bool foil = map['foil'];
                  
                  // Save the card to the database
                  await cardsProvider.addCardToCollection(
                    card,
                    amount: foil ? 0 : 1,
                    amountFoil: foil ? 1 : 0,
                  );
                }
              }
            }
          } catch (error, st) {
            log.severe('Error analyzing image', error, st);
          } finally {
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
          }
        },
      ),
      body: loading
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Karte wird gescannt...'),
              ],
            ),
          )
        : Stack(
            children: [
              // Camera preview
              _cameraPreviewWidget(),
            ],
          ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = _cameraController;

    if (_cameraController == null || !cameraController!.value.isInitialized) {
      return const Text(
        'Kamera nicht verfügbar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return CameraPreview(
        cameraController,
        // Card template overlay
        child: const CardTemplateOverlay(),
      );
    }
  }
}
