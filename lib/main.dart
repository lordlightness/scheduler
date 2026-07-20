import 'package:flutter/material.dart';

import 'app.dart';
import 'data/hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const RivermouthApp());
}
