import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../core/constants/shift_type.dart';
import '../data/models/employee.dart';

/// Builds a printable PDF of the weekly schedule.
class PdfService {
  PdfService._();

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
              pw.SizedBox(height: 12),
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
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(employee.name, style: const pw.TextStyle(fontSize: 9)),
        ),
        for (final date in weekDates)
          pw.Padding(
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
