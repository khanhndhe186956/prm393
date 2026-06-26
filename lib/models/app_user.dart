import 'user_role.dart';

enum UserStatus { active, inactive, locked }

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    this.apartmentId,
    this.nationalId,
    this.dateOfBirth,
    this.status = UserStatus.active,
  });

  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? phone;
  final String? apartmentId;
  final String? nationalId;
  final DateTime? dateOfBirth;
  final UserStatus status;

  AppUser copyWith({
    String? fullName,
    String? phone,
    String? nationalId,
    DateTime? dateOfBirth,
    UserStatus? status,
  }) {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      role: role,
      phone: phone ?? this.phone,
      apartmentId: apartmentId,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
    );
  }
}
