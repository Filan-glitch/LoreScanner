import 'package:camera/camera.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:lorescanner/pages/home_page.dart';
import 'package:lorescanner/service/database.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that the camera plugin is initialized before running the app
  // This is necessary if you are using camera features in your app.
  // If you are not using camera features, you can remove this line.
  await availableCameras(); // Uncomment if you need camera initialization

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
        home: const HomePage(),
      ),
    );
  }
}
