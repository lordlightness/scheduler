import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../core/constants/shift_type.dart';
import '../data/models/employee.dart';

/// Builds a printable PDF of the monthly schedule.
class PdfService {
  PdfService._();

  static Future<pw.Document> buildMonthlySchedule({
    required DateTime month,
    required List<Employee> employees,
    required ShiftType Function(String employeeId, DateTime date) shiftFor,
  }) async {
    final doc = pw.Document();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final monthLabel = DateFormat.yMMMM().format(month);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rivermouth Beach Bar — Schedule ($monthLabel)',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 12),
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                children: [
                  _buildHeaderRow(daysInMonth),
                  for (final employee in employees)
                    _buildEmployeeRow(employee, month, daysInMonth, shiftFor),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  static pw.TableRow _buildHeaderRow(int daysInMonth) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text('Employee', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        for (int day = 1; day <= daysInMonth; day++)
          pw.Padding(
            padding: const pw.EdgeInsets.all(2),
            child: pw.Center(child: pw.Text('$day', style: const pw.TextStyle(fontSize: 8))),
          ),
      ],
    );
  }

  static pw.TableRow _buildEmployeeRow(
    Employee employee,
    DateTime month,
    int daysInMonth,
    ShiftType Function(String employeeId, DateTime date) shiftFor,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(employee.name, style: const pw.TextStyle(fontSize: 9)),
        ),
        for (int day = 1; day <= daysInMonth; day++)
          pw.Padding(
            padding: const pw.EdgeInsets.all(2),
            child: pw.Center(
              child: pw.Text(
                shiftFor(employee.id, DateTime(month.year, month.month, day)).label,
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ),
      ],
    );
  }
}
