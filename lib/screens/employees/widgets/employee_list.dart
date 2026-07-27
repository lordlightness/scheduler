import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/employee.dart';
import '../../../providers/employee_provider.dart';
import 'edit_employee_dialog.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key, required this.employees});

  final List<Employee> employees;

  Future<void> _confirmDelete(BuildContext context, Employee employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Remove ${employee.name} from the staff list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<EmployeeProvider>().deleteEmployee(employee.id);
    }
  }

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
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, employee),
          ),
        );
      },
    );
  }
}
