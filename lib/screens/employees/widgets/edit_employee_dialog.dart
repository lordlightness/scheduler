import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/employee_role.dart';
import '../../../data/models/employee.dart';
import '../../../providers/employee_provider.dart';

Future<void> showEditEmployeeDialog(
  BuildContext context,
  Employee employee,
) {
  final controller = TextEditingController(text: employee.name);
  final formKey = GlobalKey<FormState>();
  EmployeeRole selectedRole = employee.role;
  String? submitError;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: const Text('Edit Employee'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      errorText: submitError,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<EmployeeRole>(
                    value: selectedRole,
                    decoration: const InputDecoration(labelText: 'Department'),
                    items: [
                      for (final role in EmployeeRole.values)
                        DropdownMenuItem(value: role, child: Text(role.label)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => selectedRole = value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  try {
                    await dialogContext.read<EmployeeProvider>().updateEmployee(
                          employee,
                          controller.text.trim(),
                          selectedRole,
                        );
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  } catch (e) {
                    setState(() => submitError = e.toString());
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}
