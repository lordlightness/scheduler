import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/employee.dart';
import '../../../providers/employee_provider.dart';

Future<void> showEditEmployeeDialog(
  BuildContext context,
  Employee employee,
) {
  final controller = TextEditingController(text: employee.name);
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Employee'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              dialogContext
                  .read<EmployeeProvider>()
                  .updateEmployee(employee, controller.text.trim());
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
