import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/service/initialization_service.dart';

void main() {
  group('InitializationService', () {
    late InitializationService service;

    setUp(() {
      service = InitializationService();
      service.reset(); // Reset state before each test
    });

    test('should be a singleton', () {
      final service1 = InitializationService();
      final service2 = InitializationService();
      expect(identical(service1, service2), true);
    });

    test('should not be initialized initially', () {
      expect(service.isInitialized, false);
      expect(service.cameras, null);
      expect(service.cards, null);
      expect(service.collection, null);
    });

    test('should reset state correctly', () {
      service.reset();
      expect(service.isInitialized, false);
      expect(service.cameras, null);
      expect(service.cards, null);
      expect(service.collection, null);
    });

    // Note: Full initialization tests would require mocking camera and database dependencies
    // which is beyond the scope of this minimal change implementation
  });
}