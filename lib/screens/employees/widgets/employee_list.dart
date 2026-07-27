import 'package:flutter/material.dart';

import '../../../data/models/employee.dart';
import 'edit_employee_dialog.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key, required this.employees});

  final List<Employee> employees;

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const Center(child: Text('No employees yet'));
    }
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          key: ValueKey(employee.id),
          title: Text(employee.name),
          onTap: () => showEditEmployeeDialog(context, employee),
        );
      },
    );
  }
}
