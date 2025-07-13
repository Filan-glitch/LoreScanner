import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/service/logging.dart';
import 'package:lorescanner/widgets/splash_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupRootLogger();
  log.info('Lorescanner starting up');

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  // All initialization logic is now handled in InitializationService
  // through the SplashWrapper widget
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const MyApp({super.key, required this.themeProvider});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardsProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Lore Scanner',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashWrapper(),
          );
        },
      ),
    );
  }
}
