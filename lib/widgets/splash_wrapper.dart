import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/pages/home_page.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/service/initialization_service.dart';

import '../service/api.dart';
import '../service/database.dart';

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
        _initializationStatus = 'Initializing...';
      });
      
      // Initialize all services
      await _initService.initialize();
      
      setState(() {
        _initializationStatus = 'Loading cards and collection...';
      });
      
      // Initialize CardsProvider with fetched cards and collection
      if (mounted) {
        final cardsProvider = context.read<CardsProvider>();
        _initService.initializeCardsProvider(cardsProvider);
        if(cardsProvider.cards.isEmpty) {
          await fetchCards('de').then((cards) {
            insertCards(cards);
            context.read<CardsProvider>().setCards(cards);
          });
        }
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

    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
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
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon.png', // Replace with your app logo path
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 48),
              
              // App title
              Text(
                'Lore Scanner',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 24),
              
              // Status text
              Text(
                _initializationStatus,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary.withAlpha(204),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}