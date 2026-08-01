import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

/// Ensures the user is authenticated as admin before proceeding.
/// If already authenticated this session, resolves immediately.
/// Otherwise shows a PIN prompt dialog; resolves to whether it succeeded.
Future<bool> requireAdminAuth(BuildContext context) async {
  final auth = context.read<AuthProvider>();
  if (auth.isAuthenticated) return true;

  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const _PinPromptDialog(),
  );
  return result ?? false;
}

class _PinPromptDialog extends StatefulWidget {
  const _PinPromptDialog();

  @override
  State<_PinPromptDialog> createState() => _PinPromptDialogState();
}

class _PinPromptDialogState extends State<_PinPromptDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final expectedPin = context.read<SettingsProvider>().pin;
    final success = context.read<AuthProvider>().login(
          _controller.text,
          expectedPin: expectedPin,
        );
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = 'Incorrect PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Admin PIN Required'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(labelText: 'PIN', errorText: _error),
          validator: (value) {
            if (value == null || value.isEmpty) return 'PIN is required';
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Unlock')),
      ],
    );
  }
}
