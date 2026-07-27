import 'package:flutter/foundation.dart';

/// Handles admin PIN authentication state.
///
/// The expected PIN is supplied by the caller (sourced from
/// [SettingsProvider]) so this class stays independent of storage.
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  bool login(String enteredPin, {required String expectedPin}) {
    if (enteredPin == expectedPin) {
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
