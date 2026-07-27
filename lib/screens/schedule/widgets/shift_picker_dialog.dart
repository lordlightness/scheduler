import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/shift_type.dart';
import '../../../data/models/employee.dart';
import '../../../providers/schedule_provider.dart';

Future<void> showShiftPickerDialog(
  BuildContext context, {
  required Employee employee,
  required DateTime date,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return SimpleDialog(
        title: Text('${employee.name} — ${date.day}/${date.month}'),
        children: [
          for (final shift in ShiftType.values)
            SimpleDialogOption(
              onPressed: () {
                dialogContext
                    .read<ScheduleProvider>()
                    .setShift(employee.id, date, shift);
                Navigator.of(dialogContext).pop();
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: shift.color,
                    child: Text(
                      shift.label,
                      style: const TextStyle(fontSize: 9, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(shift.fullName),
                ],
              ),
            ),
        ],
      );
    },
  );
}
