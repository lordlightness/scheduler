import 'package:hive/hive.dart';

import '../../core/constants/shift_type.dart';

part 'schedule_entry.g.dart';

@HiveType(typeId: 1)
class ScheduleEntry extends HiveObject {
  ScheduleEntry({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.shiftIndex,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String employeeId;

  /// Normalized to midnight (year, month, day only).
  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  int shiftIndex;

  ShiftType get shift => ShiftType.values[shiftIndex];
  set shift(ShiftType value) => shiftIndex = value.index;

  Map<String, dynamic> toMap() => {
        'id': id,
        'employeeId': employeeId,
        'date': date.toIso8601String(),
        'shiftIndex': shiftIndex,
      };

  factory ScheduleEntry.fromMap(Map<String, dynamic> map) => ScheduleEntry(
        id: map['id'] as String,
        employeeId: map['employeeId'] as String,
        date: DateTime.parse(map['date'] as String),
        shiftIndex: map['shiftIndex'] as int? ?? 0,
      );
}
