import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import 'widgets/add_employee_dialog.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeProvider>().employees;

    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: employees.isEmpty
          ? const Center(child: Text('No employees yet'))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee.name),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEmployeeDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
