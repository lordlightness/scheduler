import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/employee_role.dart';
import '../../../data/models/employee.dart';
import '../../../providers/employee_provider.dart';
import '../../../widgets/pin_prompt_dialog.dart';
import 'edit_employee_dialog.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key, required this.employees});

  final List<Employee> employees;

  Future<void> _handleEdit(BuildContext context, Employee employee) async {
    if (await requireAdminAuth(context)) {
      if (context.mounted) showEditEmployeeDialog(context, employee);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Employee employee) async {
    if (!await requireAdminAuth(context)) return;
    if (!context.mounted) return;

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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No employees yet'),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return ListTile(
          key: ValueKey(employee.id),
          leading: CircleAvatar(
            child: Text(employee.name.isNotEmpty ? employee.name[0] : '?'),
          ),
          title: Text(employee.name),
          subtitle: Text(employee.role.label),
          onTap: () => _handleEdit(context, employee),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, employee),
          ),
        );
      },
    );
  }
}
