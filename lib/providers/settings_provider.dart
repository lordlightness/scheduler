import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../data/hive/hive_service.dart';

/// Manages app settings persisted in Hive. Currently just the admin PIN.
class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _pin = _box.get(_pinKey, defaultValue: _defaultPin) as String;
  }

  static const String _pinKey = 'admin_pin';
  static const String _defaultPin = '1234';

  Box get _box => Hive.box(HiveService.settingsBoxName);

  late String _pin;
  String get pin => _pin;

  Future<void> updatePin(String newPin) async {
    _pin = newPin;
    await _box.put(_pinKey, newPin);
    notifyListeners();
  }
}
