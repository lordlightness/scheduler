import 'package:flutter/material.dart';

import '../core/constants/employee_role.dart';

/// A row of filter chips: "All" plus one per [EmployeeRole].
/// `null` selection means "All".
class DepartmentFilter extends StatelessWidget {
  const DepartmentFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final EmployeeRole? selected;
  final ValueChanged<EmployeeRole?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onChanged(null),
            ),
          ),
          for (final role in EmployeeRole.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(role.label),
                selected: selected == role,
                onSelected: (_) => onChanged(role),
              ),
            ),
        ],
      ),
    );
  }
}
