import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/constants/employee_role.dart';
import '../../providers/employee_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../services/pdf_service.dart';
import '../../services/share_service.dart';
import '../../widgets/department_filter.dart';
import 'widgets/shift_legend.dart';
import 'widgets/shift_picker_dialog.dart';
import 'widgets/week_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  EmployeeRole? _filter;

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final allEmployees = context.watch<EmployeeProvider>().employees;
    final employees = _filter == null
        ? allEmployees
        : allEmployees.where((e) => e.role == _filter).toList();
    final weekDates = scheduleProvider.weekDates;
    final weekLabel =
        '${DateFormat.MMMd().format(weekDates.first)} - '
        '${DateFormat.MMMd().format(weekDates.last)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export PDF',
            onPressed: employees.isEmpty
                ? null
                : () async {
                    try {
                      final doc = await PdfService.buildWeeklySchedule(
                        weekDates: weekDates,
                        employees: employees,
                        shiftFor: scheduleProvider.shiftFor,
                      );
                      await Printing.layoutPdf(onLayout: (_) => doc.save());
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to export PDF: $e')),
                        );
                      }
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: employees.isEmpty
                ? null
                : () async {
                    try {
                      final doc = await PdfService.buildWeeklySchedule(
                        weekDates: weekDates,
                        employees: employees,
                        shiftFor: scheduleProvider.shiftFor,
                      );
                      await ShareService.sharePdf(
                        doc,
                        fileName: 'schedule_$weekLabel.pdf',
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to share: $e')),
                        );
                      }
                    }
                  },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: scheduleProvider.goToPreviousWeek,
              ),
              Text(weekLabel, style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: scheduleProvider.goToNextWeek,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          DepartmentFilter(
            selected: _filter,
            onChanged: (role) => setState(() => _filter = role),
          ),
          const ShiftLegend(),
          Expanded(
            child: employees.isEmpty
                ? const Center(child: Text('No employees in this department'))
                : WeekCalendar(
                    weekDates: weekDates,
                    employees: employees,
                    shiftFor: scheduleProvider.shiftFor,
                    onCellTap: (employee, date) => showShiftPickerDialog(
                      context,
                      employee: employee,
                      date: date,
                      currentShift: scheduleProvider.shiftFor(employee.id, date),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
