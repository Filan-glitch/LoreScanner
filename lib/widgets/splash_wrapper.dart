import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/pages/home_page.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/service/initialization_service.dart';

/// Widget that handles the splash screen and app initialization
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  final InitializationService _initService = InitializationService();
  bool _isInitialized = false;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize the app and navigate to HomePage when complete
  Future<void> _initializeApp() async {
    try {
      setState(() {
        _initializationStatus = 'Initializing cameras...';
      });
      
      // Initialize all services
      await _initService.initialize();
      
      setState(() {
        _initializationStatus = 'Loading cards...';
      });
      
      // Initialize CardsProvider with fetched cards
      if (mounted) {
        final cardsProvider = context.read<CardsProvider>();
        _initService.initializeCardsProvider(cardsProvider);
      }
      
      setState(() {
        _initializationStatus = 'Ready!';
      });
      
      // Add a small delay to show the "Ready!" message
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _initializationStatus = 'Error: $e';
      });
      
      // Show error dialog after a delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  /// Show error dialog when initialization fails
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text('Failed to initialize app: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp(); // Retry initialization
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return const HomePage();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo or icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),
              
              // App title
              const Text(
                'Lore Scanner',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              
              // Status text
              Text(
                _initializationStatus,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}