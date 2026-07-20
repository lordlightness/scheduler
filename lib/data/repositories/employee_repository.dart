import 'package:hive/hive.dart';

import '../hive/hive_service.dart';
import '../models/employee.dart';

/// Data access layer for [Employee] records backed by Hive.
class EmployeeRepository {
  Box<Employee> get _box => Hive.box<Employee>(HiveService.employeeBoxName);

  List<Employee> getAll() => _box.values.toList();
}
