import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

/// Shares a generated PDF document via the platform share sheet
/// (WhatsApp, email, etc. depending on installed apps).
class ShareService {
  ShareService._();

  static Future<void> sharePdf(pw.Document doc, {required String fileName}) async {
    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Rivermouth Beach Bar — schedule',
    );
  }
}
