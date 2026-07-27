// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleEntryAdapter extends TypeAdapter<ScheduleEntry> {
  @override
  final int typeId = 1;

  @override
  ScheduleEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleEntry(
      id: fields[0] as String,
      employeeId: fields[1] as String,
      date: fields[2] as DateTime,
      shiftIndex: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.employeeId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.shiftIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
