import 'package:hive/hive.dart';

import '../../core/constants/employee_role.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  Employee({
    required this.id,
    required this.name,
    this.isActive = true,
    this.roleIndex = 0,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isActive;

  @HiveField(3)
  int roleIndex;

  EmployeeRole get role => EmployeeRole.values[roleIndex];
  set role(EmployeeRole value) => roleIndex = value.index;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'isActive': isActive,
        'roleIndex': roleIndex,
      };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
        id: map['id'] as String,
        name: map['name'] as String,
        isActive: map['isActive'] as bool? ?? true,
        roleIndex: map['roleIndex'] as int? ?? 0,
      );
}
