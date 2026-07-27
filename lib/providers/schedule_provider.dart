import 'package:flutter/foundation.dart';

import '../core/constants/shift_type.dart';
import '../core/utils/id_generator.dart';
import '../data/models/schedule_entry.dart';
import '../data/repositories/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider(this._repository) {
    _loadMonth(_visibleMonth);
  }

  final ScheduleRepository _repository;

  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month);
  List<ScheduleEntry> _entries = [];

  DateTime get visibleMonth => _visibleMonth;
  List<ScheduleEntry> get entries => List.unmodifiable(_entries);

  void _loadMonth(DateTime month) {
    _entries = _repository.getForMonth(month.year, month.month);
  }

  void goToNextMonth() {
    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    _loadMonth(_visibleMonth);
    notifyListeners();
  }

  void goToPreviousMonth() {
    _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    _loadMonth(_visibleMonth);
    notifyListeners();
  }

  ShiftType shiftFor(String employeeId, DateTime date) {
    final entry = _repository.getForEmployeeAndDate(employeeId, date);
    return entry?.shift ?? ShiftType.off;
  }

  Future<void> clearShift(String employeeId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existing = _repository.getForEmployeeAndDate(
      employeeId,
      normalizedDate,
    );
    if (existing != null) {
      await _repository.delete(existing.id);
      _loadMonth(_visibleMonth);
      notifyListeners();
    }
  }

  Future<void> setShift(
    String employeeId,
    DateTime date,
    ShiftType shift,
  ) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existing = _repository.getForEmployeeAndDate(
      employeeId,
      normalizedDate,
    );
    if (existing != null) {
      existing.shift = shift;
      await _repository.upsert(existing);
    } else {
      await _repository.upsert(
        ScheduleEntry(
          id: generateId(),
          employeeId: employeeId,
          date: normalizedDate,
          shiftIndex: shift.index,
        ),
      );
    }
    _loadMonth(_visibleMonth);
    notifyListeners();
  }
}
