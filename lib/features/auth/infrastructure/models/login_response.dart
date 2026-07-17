import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

class LoginResponse {
  final String userId;
  final String userName;
  final String email;
  final UserRole role;
  final String token;
  final bool isActive;

  const LoginResponse({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.token,
    required this.isActive,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      role: UserRole.fromString(json['roleName']),
      token: json['token'],
      isActive: json['isActive'] ?? false,
    );
  }

  AuthSession toDomain() {
    return AuthSession(
      user: User(userId: userId, userName: userName, email: email, role: role),
      token: token,
    );
  }
}
