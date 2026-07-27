import 'package:flutter_test/flutter_test.dart';
import 'package:rivermouth_scheduler/core/constants/shift_type.dart';

void main() {
  group('ShiftTypeX', () {
    test('labels match expected short codes', () {
      expect(ShiftType.morning.label, 'M');
      expect(ShiftType.middle.label, 'Md');
      expect(ShiftType.afternoon.label, 'A');
      expect(ShiftType.off.label, 'Off');
    });

    test('each shift has a distinct color', () {
      final colors = ShiftType.values.map((s) => s.color).toSet();
      expect(colors.length, ShiftType.values.length);
    });
  });
}
