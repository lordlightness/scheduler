import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/shift_type.dart';
import '../../../data/models/employee.dart';

/// Renders a scrollable grid: one row per employee, one column per day
/// of the visible week. Tapping a cell is handled by the caller via
/// [onCellTap].
class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    super.key,
    required this.weekDates,
    required this.employees,
    required this.shiftFor,
    required this.onCellTap,
  });

  final List<DateTime> weekDates;
  final List<Employee> employees;
  final ShiftType Function(String employeeId, DateTime date) shiftFor;
  final void Function(Employee employee, DateTime date) onCellTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(56),
          columnWidths: const {0: FixedColumnWidth(100)},
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            _buildHeaderRow(context),
            for (final employee in employees) _buildEmployeeRow(employee),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        for (final date in weekDates)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.E().format(date),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text('${date.day}', style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
      ],
    );
  }

  TableRow _buildEmployeeRow(Employee employee) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(employee.name, overflow: TextOverflow.ellipsis),
        ),
        for (final date in weekDates) _buildCell(employee, date),
      ],
    );
  }

  Widget _buildCell(Employee employee, DateTime date) {
    final shift = shiftFor(employee.id, date);
    return RepaintBoundary(
      child: InkWell(
        onTap: () => onCellTap(employee, date),
        child: Container(
          alignment: Alignment.center,
          color: shift.color.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(shift.label, style: const TextStyle(fontSize: 11)),
        ),
      ),
    );
  }
}
