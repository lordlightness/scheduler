import 'package:flutter/material.dart';

import 'app.dart';
import 'data/hive/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HiveService.init();
    runApp(const RivermouthApp());
  } catch (e) {
    runApp(_StartupErrorApp(error: e.toString()));
  }
}

/// Minimal fallback UI shown only if local storage fails to initialize.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Failed to start app: $error'),
          ),
        ),
      ),
    );
  }
}
