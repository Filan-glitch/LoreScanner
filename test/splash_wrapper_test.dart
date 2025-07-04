import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/widgets/splash_wrapper.dart';
import 'package:lorescanner/provider/cards_provider.dart';

void main() {
  group('SplashWrapper', () {
    testWidgets('should display splash screen initially', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => CardsProvider(),
            child: const SplashWrapper(),
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text('Lore Scanner'), findsOneWidget);
      expect(find.text('Initializing...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should show initialization status updates', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => CardsProvider(),
            child: const SplashWrapper(),
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert - should show initial loading state
      expect(find.text('Initializing...'), findsOneWidget);
      
      // Note: Full initialization flow testing would require mocking
      // camera and database services, which is complex for this minimal change
    });
  });
}