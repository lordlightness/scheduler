import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/employee_role.dart';
import '../core/utils/id_generator.dart';
import '../data/models/employee.dart';
import '../data/repositories/employee_repository.dart';
import '../services/sync_service.dart';

/// The staff on record when the bar first sets up the app.
/// All seeded as Waiters (existing staff role).
const List<String> kInitialEmployeeNames = [
  'Dellas',
  'Goler',
  'Deo',
  'Dian',
  'Desi',
  'Melissa',
];

class EmployeeProvider extends ChangeNotifier {
  EmployeeProvider(this._repository, [SyncService? sync])
      : _sync = sync ?? SyncService.instance {
    _load();
    _listenForRemoteChanges();
  }

  final EmployeeRepository _repository;
  final SyncService _sync;
  StreamSubscription? _remoteSub;
  List<Employee> _employees = [];

  List<Employee> get employees => List.unmodifiable(_employees);

  void _load() {
    var all = _repository.getAll();
    if (all.isEmpty) {
      _seedInitialEmployees();
      all = _repository.getAll();
    }
    _employees = all;
    notifyListeners();
  }

  void _seedInitialEmployees() {
    for (final name in kInitialEmployeeNames) {
      final employee = Employee(
        id: generateId(),
        name: name,
        roleIndex: EmployeeRole.waiter.index,
      );
      _repository.add(employee);
      _sync.pushDocument(
        SyncService.employeesCollection,
        employee.id,
        employee.toMap(),
      );
    }
  }

  /// Applies changes made on other devices (via Firestore) to local Hive.
  /// No-ops entirely if Firebase isn't configured.
  void _listenForRemoteChanges() {
    _remoteSub = _sync
        .watchCollection(SyncService.employeesCollection)
        .listen((changes) {
      var changed = false;
      for (final change in changes) {
        final data = change.doc.data();
        if (change.type == DocumentChangeType.removed || data == null) {
          _repository.delete(change.doc.id);
        } else {
          _repository.add(Employee.fromMap(data));
        }
        changed = true;
      }
      if (changed) {
        _employees = _repository.getAll();
        notifyListeners();
      }
    });
  }

  bool _nameTaken(String name, {String? excludingId}) {
    final normalized = name.trim().toLowerCase();
    return _employees.any(
      (e) => e.id != excludingId && e.name.trim().toLowerCase() == normalized,
    );
  }

  Future<void> addEmployee(String name, EmployeeRole role) async {
    if (_nameTaken(name)) {
      throw ArgumentError('An employee named "$name" already exists');
    }
    final employee = Employee(
      id: generateId(),
      name: name,
      roleIndex: role.index,
    );
    await _repository.add(employee);
    _employees = _repository.getAll();
    notifyListeners();
    _sync.pushDocument(
      SyncService.employeesCollection,
      employee.id,
      employee.toMap(),
    );
  }

  Future<void> updateEmployee(
    Employee employee,
    String newName,
    EmployeeRole role,
  ) async {
    if (_nameTaken(newName, excludingId: employee.id)) {
      throw ArgumentError('An employee named "$newName" already exists');
    }
    employee.name = newName;
    employee.role = role;
    await _repository.update(employee);
    _employees = _repository.getAll();
    notifyListeners();
    _sync.pushDocument(
      SyncService.employeesCollection,
      employee.id,
      employee.toMap(),
    );
  }

  Future<void> deleteEmployee(String id) async {
    await _repository.delete(id);
    _employees = _repository.getAll();
    notifyListeners();
    _sync.deleteDocument(SyncService.employeesCollection, id);
  }

  @override
  void dispose() {
    _remoteSub?.cancel();
    super.dispose();
  }
}
