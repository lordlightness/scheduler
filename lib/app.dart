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
import 'screens/schedule/schedule_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/pin_prompt_dialog.dart';

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
        home: const _HomeShell(),
      ),
    );
  }
}

/// Bottom-navigation shell switching between Employees, Schedule, and
/// Settings. The app opens directly here (view mode) — admin actions
/// (add/edit/delete, shift changes, Settings) each prompt for the PIN
/// via [requireAdminAuth] the first time they're used per session.
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

  Future<void> _onDestinationSelected(int index) async {
    if (index == 2) {
      final unlocked = await requireAdminAuth(context);
      if (!unlocked) return;
    }
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onDestinationSelected,
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
