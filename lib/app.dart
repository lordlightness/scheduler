import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/employee_repository.dart';
import 'data/repositories/schedule_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/employees/employee_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/settings/settings_screen.dart';

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
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(ScheduleRepository()),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
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
    return const _HomeShell();
  }
}

/// Simple bottom-navigation shell switching between the Employees and
/// Schedule screens.
class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  static const _screens = [
    EmployeeScreen(),
    ScheduleScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Employees'),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
