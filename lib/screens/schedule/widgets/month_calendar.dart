import 'package:flutter/material.dart';

import '../../../core/constants/shift_type.dart';
import '../../../data/models/employee.dart';

/// Renders a scrollable grid: one row per employee, one column per day
/// of the visible month. Tapping a cell is handled by the caller via
/// [onCellTap].
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.employees,
    required this.shiftFor,
    required this.onCellTap,
  });

  final DateTime month;
  final List<Employee> employees;
  final ShiftType Function(String employeeId, DateTime date) shiftFor;
  final void Function(Employee employee, DateTime date) onCellTap;

  int get _daysInMonth => DateTime(month.year, month.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(40),
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
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        for (int day = 1; day <= _daysInMonth; day++)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Center(child: Text('$day')),
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
        for (int day = 1; day <= _daysInMonth; day++)
          _buildCell(employee, DateTime(month.year, month.month, day)),
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
