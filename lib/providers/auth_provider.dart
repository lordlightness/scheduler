import 'package:flutter/foundation.dart';

/// Handles admin PIN authentication state.
///
/// The PIN itself is sourced from [SettingsProvider] once Hive-backed
/// settings storage is introduced in Phase 4. Until then, a sensible
/// default is used so the login flow is testable end-to-end.
class AuthProvider extends ChangeNotifier {
  static const String _defaultPin = '1234';

  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  bool login(String enteredPin) {
    if (enteredPin == _defaultPin) {
      _isAuthenticated = true;
      _errorMessage = null;
      notifyListeners();
      return true;
    }
    _errorMessage = 'Incorrect PIN';
    notifyListeners();
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
