import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final settings = context.read<SettingsProvider>();
    if (_currentPinController.text != settings.pin) {
      setState(() => _error = 'Current PIN is incorrect');
      return;
    }

    await settings.updatePin(_newPinController.text);
    setState(() => _error = null);
    _currentPinController.clear();
    _newPinController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change Admin PIN',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Current PIN',
                  errorText: _error,
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New PIN'),
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'PIN must be at least 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
