import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import '../../providers/schedule_provider.dart';
import 'widgets/month_calendar.dart';
import 'widgets/shift_picker_dialog.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final employees = context.watch<EmployeeProvider>().employees;
    final monthLabel = DateFormat.yMMMM().format(scheduleProvider.visibleMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: scheduleProvider.goToPreviousMonth,
              ),
              Text(monthLabel, style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: scheduleProvider.goToNextMonth,
              ),
            ],
          ),
        ),
      ),
      body: employees.isEmpty
          ? const Center(child: Text('Add employees first'))
          : MonthCalendar(
              month: scheduleProvider.visibleMonth,
              employees: employees,
              shiftFor: scheduleProvider.shiftFor,
              onCellTap: (employee, date) => showShiftPickerDialog(
                context,
                employee: employee,
                date: date,
                currentShift: scheduleProvider.shiftFor(employee.id, date),
              ),
            ),
    );
  }
}
