import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  Employee({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isActive;
}
