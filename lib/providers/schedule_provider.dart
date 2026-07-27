import 'package:flutter/foundation.dart';

import '../core/constants/shift_type.dart';
import '../core/utils/id_generator.dart';
import '../data/models/schedule_entry.dart';
import '../data/repositories/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider(this._repository) {
    _loadWeek(_visibleWeekStart);
  }

  final ScheduleRepository _repository;

  DateTime _visibleWeekStart = _startOfWeek(DateTime.now());
  List<ScheduleEntry> _entries = [];
  Map<String, ScheduleEntry> _entriesByKey = {};

  /// Monday of the currently visible week.
  DateTime get visibleWeekStart => _visibleWeekStart;

  /// The 7 dates (Mon–Sun) making up the visible week.
  List<DateTime> get weekDates =>
      List.generate(7, (i) => _visibleWeekStart.add(Duration(days: i)));

  List<ScheduleEntry> get entries => List.unmodifiable(_entries);

  static DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  String _keyFor(String employeeId, DateTime date) =>
      '${employeeId}_${date.year}-${date.month}-${date.day}';

  void _loadWeek(DateTime weekStart) {
    _entries = _repository.getForWeek(weekStart);
    _entriesByKey = {
      for (final entry in _entries) _keyFor(entry.employeeId, entry.date): entry,
    };
  }

  void goToNextWeek() {
    _visibleWeekStart = _visibleWeekStart.add(const Duration(days: 7));
    _loadWeek(_visibleWeekStart);
    notifyListeners();
  }

  void goToPreviousWeek() {
    _visibleWeekStart = _visibleWeekStart.subtract(const Duration(days: 7));
    _loadWeek(_visibleWeekStart);
    notifyListeners();
  }

  ShiftType shiftFor(String employeeId, DateTime date) {
    final entry = _entriesByKey[_keyFor(employeeId, date)];
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
      _loadWeek(_visibleWeekStart);
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
    _loadWeek(_visibleWeekStart);
    notifyListeners();
  }
}
