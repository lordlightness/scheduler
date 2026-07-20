import 'package:hive_flutter/hive_flutter.dart';

import '../models/employee.dart';

/// Centralizes Hive box names and startup initialization.
class HiveService {
  HiveService._();

  static const String employeeBoxName = 'employees';
  static const String scheduleBoxName = 'schedule_entries';
  static const String settingsBoxName = 'settings';

  /// Initializes Hive, registers type adapters, and opens all boxes used
  /// by the app. Must be called once before [runApp].
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EmployeeAdapter());

    await Hive.openBox<Employee>(employeeBoxName);
    await Hive.openBox(scheduleBoxName);
    await Hive.openBox(settingsBoxName);
  }
}
