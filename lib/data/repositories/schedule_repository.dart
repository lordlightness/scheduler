import 'package:hive/hive.dart';

import '../hive/hive_service.dart';
import '../models/schedule_entry.dart';

/// Data access layer for [ScheduleEntry] records backed by Hive.
class ScheduleRepository {
  Box<ScheduleEntry> get _box =>
      Hive.box<ScheduleEntry>(HiveService.scheduleBoxName);

  /// Returns all entries whose date falls within the 7-day window
  /// starting at [weekStart] (inclusive) through [weekStart] + 6 days.
  List<ScheduleEntry> getForWeek(DateTime weekStart) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 6));
    return _box.values
        .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
        .toList();
  }

  ScheduleEntry? getForEmployeeAndDate(String employeeId, DateTime date) {
    try {
      return _box.values.firstWhere(
        (e) =>
            e.employeeId == employeeId &&
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } on StateError {
      return null;
    }
  }

  Future<void> upsert(ScheduleEntry entry) => _box.put(entry.id, entry);

  Future<void> delete(String id) => _box.delete(id);
}
