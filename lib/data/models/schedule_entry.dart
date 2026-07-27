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
}
