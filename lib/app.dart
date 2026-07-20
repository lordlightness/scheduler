import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/employee_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/employee_provider.dart';
import 'screens/login/login_screen.dart';

/// Root widget of Rivermouth Scheduler.
class RivermouthApp extends StatelessWidget {
  const RivermouthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(EmployeeRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Rivermouth Scheduler',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Shows the login screen until the admin PIN is verified.
///
/// The authenticated home (employee/schedule screens) is added in Phase 2.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    if (!isAuthenticated) {
      return const LoginScreen();
    }
    return const Scaffold(
      body: Center(child: Text('Logged in')),
    );
  }
}
