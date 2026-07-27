import 'package:flutter_test/flutter_test.dart';
import 'package:rivermouth_scheduler/providers/auth_provider.dart';

void main() {
  group('AuthProvider', () {
    test('login succeeds with correct PIN', () {
      final auth = AuthProvider();
      final result = auth.login('1234', expectedPin: '1234');

      expect(result, isTrue);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.errorMessage, isNull);
    });

    test('login fails with incorrect PIN', () {
      final auth = AuthProvider();
      final result = auth.login('0000', expectedPin: '1234');

      expect(result, isFalse);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.errorMessage, isNotNull);
    });

    test('logout resets authenticated state', () {
      final auth = AuthProvider()..login('1234', expectedPin: '1234');
      auth.logout();

      expect(auth.isAuthenticated, isFalse);
    });
  });
}
