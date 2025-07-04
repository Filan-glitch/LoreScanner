import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lorescanner/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should show splash screen on app launch', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is displayed
      expect(find.text('Lore Scanner'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for initialization (this might take time in real scenarios)
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Note: In a real scenario, we would check that the HomePage is shown
      // after initialization completes, but this requires proper mocking
      // of camera and database services
    });
  });
}