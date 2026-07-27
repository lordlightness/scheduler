import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/constants/employee_role.dart';
import '../core/constants/shift_type.dart';
import '../data/models/employee.dart';

class PdfService {
  PdfService._();

  static PdfColor _departmentColor(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.waiter:
        return PdfColor.fromInt(0xFFFFF176);
      case EmployeeRole.bar:
        return PdfColor.fromInt(0xFFD2B48C);
      case EmployeeRole.kitchen:
        return PdfColor.fromInt(0xFF81C784);
      case EmployeeRole.admin:
        return PdfColor.fromInt(0xFF64B5F6);
    }
  }

  static PdfColor _cellColor(EmployeeRole role, ShiftType shift) {
    switch (shift) {
      case ShiftType.off:
        return PdfColor.fromInt(0xFFE57373);
      case ShiftType.middle:
        return PdfColor.fromInt(0xFF64B5F6);
      case ShiftType.morning:
      case ShiftType.afternoon:
        return _departmentColor(role);
    }
  }

  static Future<pw.Document> buildWeeklySchedule({
    required List<DateTime> weekDates,
    required List<Employee> employees,
    required ShiftType Function(
      String employeeId,
      DateTime date,
    ) shiftFor,
  }) async {
    final doc = pw.Document();

    final weekLabel =
        '${DateFormat.MMMd().format(weekDates.first)} - '
        '${DateFormat.MMMd().format(weekDates.last)}';

    final sortedEmployees = [...employees];

    const roleOrder = {
      EmployeeRole.waiter: 0,
      EmployeeRole.bar: 1,
      EmployeeRole.kitchen: 2,
      EmployeeRole.admin: 3,
    };

    sortedEmployees.sort((a, b) {
      final r =
          roleOrder[a.role]!.compareTo(roleOrder[b.role]!);

      if (r != 0) return r;

      return a.name.compareTo(b.name);
    });

    final waiters = sortedEmployees
        .where((e) => e.role == EmployeeRole.waiter)
        .toList();

    final bars = sortedEmployees
        .where((e) => e.role == EmployeeRole.bar)
        .toList();

    final kitchens = sortedEmployees
        .where((e) => e.role == EmployeeRole.kitchen)
        .toList();

    final admins = sortedEmployees
        .where((e) => e.role == EmployeeRole.admin)
        .toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Text(
            'Rivermouth Beach Bar',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Text(
            'Weekly Schedule',
            style: const pw.TextStyle(fontSize: 12),
          ),

          pw.Text(
            weekLabel,
            style: const pw.TextStyle(fontSize: 10),
          ),

          pw.SizedBox(height: 10),

          _buildLegend(),

          pw.SizedBox(height: 15),

          if (waiters.isNotEmpty)
            _buildDepartmentTable(
              title: 'WAITERS',
              employees: waiters,
              weekDates: weekDates,
              shiftFor: shiftFor,
            ),

          if (bars.isNotEmpty)
            _buildDepartmentTable(
              title: 'BAR',
              employees: bars,
              weekDates: weekDates,
              shiftFor: shiftFor,
            ),

          if (kitchens.isNotEmpty)
            _buildDepartmentTable(
              title: 'KITCHEN',
              employees: kitchens,
              weekDates: weekDates,
              shiftFor: shiftFor,
            ),

          if (admins.isNotEmpty)
            _buildDepartmentTable(
              title: 'ADMIN',
              employees: admins,
              weekDates: weekDates,
              shiftFor: shiftFor,
            ),
        ],
      ),
    );

    return doc;
  }

  static pw.Widget _buildLegend() {
    pw.Widget item(
      String text,
      PdfColor color,
    ) {
      return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            width: 10,
            height: 10,
            color: color,
          ),
          pw.SizedBox(width: 4),
          pw.Text(
            text,
            style: const pw.TextStyle(fontSize: 8),
          ),
          pw.SizedBox(width: 10),
        ],
      );
    }

    return pw.Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        item('Waiter', _departmentColor(EmployeeRole.waiter)),
        item('Bar', _departmentColor(EmployeeRole.bar)),
        item('Kitchen', _departmentColor(EmployeeRole.kitchen)),
        item('Admin', _departmentColor(EmployeeRole.admin)),
        item('OFF', PdfColor.fromInt(0xFFE57373)),
        item('Middle', PdfColor.fromInt(0xFF64B5F6)),
      ],
    );
  }

  static pw.TableRow _buildHeaderRow(
    List<DateTime> weekDates,
  ) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Employee',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        for (final date in weekDates)
          pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Center(
              child: pw.Text(
                '${DateFormat.E().format(date)}\n${date.day}',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 8,
                ),
              ),
            ),
          ),
      ],
    );
  }

    static pw.Widget _buildDepartmentTable({
    required String title,
    required List<Employee> employees,
    required List<DateTime> weekDates,
    required ShiftType Function(
      String employeeId,
      DateTime date,
    ) shiftFor,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey800,
            borderRadius: const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(3),
              topRight: pw.Radius.circular(3),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),

        pw.Table(
          border: pw.TableBorder.all(
            width: .5,
            color: PdfColors.grey700,
          ),
          children: [
            _buildHeaderRow(weekDates),

            for (final employee in employees)
              _buildEmployeeRow(
                employee,
                weekDates,
                shiftFor,
              ),
          ],
        ),

        pw.SizedBox(height: 14),
      ],
    );
  }

  static pw.TableRow _buildEmployeeRow(
    Employee employee,
    List<DateTime> weekDates,
    ShiftType Function(
      String employeeId,
      DateTime date,
    ) shiftFor,
  ) {
    return pw.TableRow(
      children: [
        pw.Container(
          color: _departmentColor(employee.role),
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            employee.name,
            style: const pw.TextStyle(
              fontSize: 9,
            ),
          ),
        ),

        for (final date in weekDates)
          pw.Container(
            alignment: pw.Alignment.center,
            color: _cellColor(
              employee.role,
              shiftFor(employee.id, date),
            ),
            padding: const pw.EdgeInsets.symmetric(
              vertical: 4,
            ),
            child: pw.Text(
              shiftFor(
                employee.id,
                date,
              ).label,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ),
      ],
    );
  }
}
