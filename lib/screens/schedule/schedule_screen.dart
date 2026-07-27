import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../services/pdf_service.dart';
import '../../services/share_service.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Export PDF',
            onPressed: employees.isEmpty
                ? null
                : () async {
                    final doc = await PdfService.buildMonthlySchedule(
                      month: scheduleProvider.visibleMonth,
                      employees: employees,
                      shiftFor: scheduleProvider.shiftFor,
                    );
                    await Printing.layoutPdf(
                      onLayout: (_) => doc.save(),
                    );
                  },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: employees.isEmpty
                ? null
                : () async {
                    final doc = await PdfService.buildMonthlySchedule(
                      month: scheduleProvider.visibleMonth,
                      employees: employees,
                      shiftFor: scheduleProvider.shiftFor,
                    );
                    await ShareService.sharePdf(
                      doc,
                      fileName: 'schedule_$monthLabel.pdf',
                    );
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
