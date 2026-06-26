enum UserRole {
  admin,
  staff,
  resident;

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.resident:
        return 'Resident';
    }
  }

  String get homeRoute {
    switch (this) {
      case UserRole.admin:
        return '/admin';
      case UserRole.staff:
        return '/staff';
      case UserRole.resident:
        return '/resident';
    }
  }
}
