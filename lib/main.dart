import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/widgets/splash_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // All initialization logic is now handled in InitializationService
  // through the SplashWrapper widget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardsProvider(),
      child: MaterialApp(
        title: 'Lore Scanner',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashWrapper(),
      ),
    );
  }
}
