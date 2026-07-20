import 'package:flutter/material.dart';

void main() {
  runApp(const RivermouthApp());
}

/// Placeholder root widget.
/// Replaced with the real app shell in a later setup step.
class RivermouthApp extends StatelessWidget {
  const RivermouthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Rivermouth Scheduler')),
      ),
    );
  }
}
