import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

/// Root widget of Rivermouth Scheduler.
class RivermouthApp extends StatelessWidget {
  const RivermouthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rivermouth Scheduler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _AppPlaceholder(),
    );
  }
}

/// Temporary home until the login screen is wired in the next step.
class _AppPlaceholder extends StatelessWidget {
  const _AppPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
