import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/employee_role.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/department_filter.dart';
import '../../widgets/pin_prompt_dialog.dart';
import 'widgets/add_employee_dialog.dart';
import 'widgets/employee_list.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  EmployeeRole? _filter;

  @override
  Widget build(BuildContext context) {
    final allEmployees = context.watch<EmployeeProvider>().employees;
    final employees = _filter == null
        ? allEmployees
        : allEmployees.where((e) => e.role == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: Column(
        children: [
          DepartmentFilter(
            selected: _filter,
            onChanged: (role) => setState(() => _filter = role),
          ),
          Expanded(child: EmployeeList(employees: employees)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await requireAdminAuth(context)) {
            if (context.mounted) showAddEmployeeDialog(context);
          }
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
