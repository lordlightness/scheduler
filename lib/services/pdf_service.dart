import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../core/constants/employee_role.dart';
import '../core/constants/shift_type.dart';
import '../data/models/employee.dart';

/// Builds a printable PDF of the weekly schedule, with cells colored by
/// department (and OFF/Middle shifts always overriding to red/blue,
/// matching the bar's existing paper roster convention).
class PdfService {
  PdfService._();

  static PdfColor _departmentColor(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.waiter:
        return PdfColor.fromInt(0xFFFFF176); // yellow
      case EmployeeRole.bar:
        return PdfColor.fromInt(0xFFD2B48C); // tan
      case EmployeeRole.kitchen:
        return PdfColor.fromInt(0xFF81C784); // green
      case EmployeeRole.admin:
        return PdfColor.fromInt(0xFF64B5F6); // blue
    }
  }

  static PdfColor _cellColor(EmployeeRole role, ShiftType shift) {
    switch (shift) {
      case ShiftType.off:
        return PdfColor.fromInt(0xFFE57373); // red
      case ShiftType.middle:
        return PdfColor.fromInt(0xFF64B5F6); // blue
      case ShiftType.morning:
      case ShiftType.afternoon:
        return _departmentColor(role);
    }
  }

  static Future<pw.Document> buildWeeklySchedule({
    required List<DateTime> weekDates,
    required List<Employee> employees,
    required ShiftType Function(String employeeId, DateTime date) shiftFor,
  }) async {
    final doc = pw.Document();
    final weekLabel =
        '${DateFormat.MMMd().format(weekDates.first)} - '
        '${DateFormat.MMMd().format(weekDates.last)}';

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rivermouth Beach Bar — Schedule ($weekLabel)',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              _buildLegend(),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildHeaderRow(weekDates),
                  for (final employee in employees)
                    _buildEmployeeRow(employee, weekDates, shiftFor),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  static pw.Widget _buildLegend() {
    pw.Widget swatch(String label, PdfColor color) => pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Container(width: 10, height: 10, color: color),
            pw.SizedBox(width: 4),
            pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
            pw.SizedBox(width: 10),
          ],
        );

    return pw.Wrap(
      children: [
        for (final role in EmployeeRole.values) swatch(role.label, _departmentColor(role)),
        swatch('Off', PdfColor.fromInt(0xFFE57373)),
        swatch('Middle', PdfColor.fromInt(0xFF64B5F6)),
      ],
    );
  }

  static pw.TableRow _buildHeaderRow(List<DateTime> weekDates) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text('Employee', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        for (final date in weekDates)
          pw.Padding(
            padding: const pw.EdgeInsets.all(2),
            child: pw.Center(
              child: pw.Text(
                '${DateFormat.E().format(date)} ${date.day}',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ),
      ],
    );
  }

  static pw.TableRow _buildEmployeeRow(
    Employee employee,
    List<DateTime> weekDates,
    ShiftType Function(String employeeId, DateTime date) shiftFor,
  ) {
    return pw.TableRow(
      children: [
        pw.Container(
          color: _departmentColor(employee.role),
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(employee.name, style: const pw.TextStyle(fontSize: 9)),
        ),
        for (final date in weekDates)
          pw.Container(
            color: _cellColor(employee.role, shiftFor(employee.id, date)),
            padding: const pw.EdgeInsets.all(2),
            child: pw.Center(
              child: pw.Text(
                shiftFor(employee.id, date).label,
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ),
      ],
    );
  }
}
