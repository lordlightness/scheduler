import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/employee_provider.dart';

/// Shows a dialog to add a new employee. Returns after the employee
/// has been saved, or immediately if the user cancels.
Future<void> showAddEmployeeDialog(BuildContext context) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? submitError;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: const Text('Add Employee'),
            content: Form(
              key: formKey,
              child: TextFormField(
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
                    await dialogContext
                        .read<EmployeeProvider>()
                        .addEmployee(controller.text.trim());
                    if (dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  } catch (e) {
                    setState(() => submitError = e.toString());
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
