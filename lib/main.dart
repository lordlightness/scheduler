import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/hive/hive_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HiveService.init();
    await _initFirebaseIfConfigured();
    runApp(const RivermouthApp());
  } catch (e) {
    runApp(_StartupErrorApp(error: e.toString()));
  }
}

/// Online sync is optional: if Firebase hasn't been set up yet
/// (`flutterfire configure` not run), this fails silently and the app
/// keeps working fully offline via Hive.
Future<void> _initFirebaseIfConfigured() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase not configured — running offline-only. ($e)');
    }
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
