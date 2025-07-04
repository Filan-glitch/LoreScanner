import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/widgets/found_cards_overview.dart';
import 'package:lorescanner/service/initialization_service.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';

import '../service/cards_analysis.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController _cameraController;
  bool _isInitialized = false;
  bool loading = false;
  final InitializationService _initService = InitializationService();

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeCameraController() async {
    // Get cameras from the centralized initialization service
    final cameras = _initService.cameras;
    if (cameras == null || cameras.isEmpty) {
      print('No cameras available from initialization service');
      return;
    }

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );

    try {
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera controller: $e');
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
    if (!_cameraController.value.isInitialized) {
      print('Error: Camera is not initialized');
      return null;
    }
    try {
      final image = await _cameraController.takePicture();
      // Handle the captured image here
      print('Picture taken: ${image.path}');
      return image;
    } catch (e) {
      print('Error taking picture: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    
    // Check if everything is properly initialized
    if (!_isInitialized || cardsProvider.cards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan eine Karte...'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera_alt),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            await _takePicture().then((image) {
              if (image != null) {
                // Analyze the image
                analyzeImage(File(image.path), cardsProvider.cards).then((foundCards) async {
                  print('Found cards: ${foundCards.length}');
                  final Map<String, dynamic>? map = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoundCardsOverview(foundCards: foundCards.toList()),
                    ),
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
                    // Show a snackbar with the result
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Karte ${card.simpleName} (${foil ? 'Foil' : 'Normal'}) gespeichert')),
                    );
                  }
                }).catchError((error) {
                  print('Error analyzing image: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fehler beim Analysieren des Bildes')),
                  );
                });
              }
            });
            setState(() {
              loading = false;
            });
          }
      ),
      body: loading ?
        const Center(child: CircularProgressIndicator()) :
        CameraPreview(_cameraController),
    );
  }
}
