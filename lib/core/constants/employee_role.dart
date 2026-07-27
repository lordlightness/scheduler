/// Department/role an employee belongs to, used to group and filter
/// the schedule (Waiters, Bar, Kitchen, Admin).
enum EmployeeRole { waiter, bar, kitchen, admin }

extension EmployeeRoleX on EmployeeRole {
  String get label {
    switch (this) {
      case EmployeeRole.waiter:
        return 'Waiter';
      case EmployeeRole.bar:
        return 'Bar';
      case EmployeeRole.kitchen:
        return 'Kitchen';
      case EmployeeRole.admin:
        return 'Admin';
    }
  }
}
