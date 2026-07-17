enum UserRole {
  patient,
  doctor,
  admin,
  unknown;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return UserRole.doctor;
      case 'patient':
        return UserRole.patient;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }
}

class User {
  final String userId;
  final String userName;
  final String email;
  final UserRole role;

  const User({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
  });
}
