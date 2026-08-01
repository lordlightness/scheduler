import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/shift_type.dart';
import '../core/utils/id_generator.dart';
import '../data/models/schedule_entry.dart';
import '../data/repositories/schedule_repository.dart';
import '../services/sync_service.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider(this._repository, [SyncService? sync])
      : _sync = sync ?? SyncService.instance {
    _loadWeek(_visibleWeekStart);
    _listenForRemoteChanges();
  }

  final ScheduleRepository _repository;
  final SyncService _sync;
  StreamSubscription? _remoteSub;

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

  /// Applies changes made on other devices (via Firestore) to local Hive.
  /// No-ops entirely if Firebase isn't configured.
  void _listenForRemoteChanges() {
    _remoteSub = _sync
        .watchCollection(SyncService.scheduleEntriesCollection)
        .listen((changes) {
      var changed = false;
      for (final change in changes) {
        final data = change.doc.data();
        if (change.type == DocumentChangeType.removed || data == null) {
          _repository.delete(change.doc.id);
        } else {
          _repository.upsert(ScheduleEntry.fromMap(data));
        }
        changed = true;
      }
      if (changed) {
        _loadWeek(_visibleWeekStart);
        notifyListeners();
      }
    });
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
      _sync.deleteDocument(SyncService.scheduleEntriesCollection, existing.id);
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
    final ScheduleEntry entry;
    if (existing != null) {
      existing.shift = shift;
      await _repository.upsert(existing);
      entry = existing;
    } else {
      entry = ScheduleEntry(
        id: generateId(),
        employeeId: employeeId,
        date: normalizedDate,
        shiftIndex: shift.index,
      );
      await _repository.upsert(entry);
    }
    _loadWeek(_visibleWeekStart);
    notifyListeners();
    _sync.pushDocument(
      SyncService.scheduleEntriesCollection,
      entry.id,
      entry.toMap(),
    );
  }

  @override
  void dispose() {
    _remoteSub?.cancel();
    super.dispose();
  }
}
