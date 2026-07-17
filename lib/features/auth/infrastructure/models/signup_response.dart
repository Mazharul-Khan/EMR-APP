import 'package:emr_app/features/auth/domain/entities/user.dart';

class SignupResponse {
  final String userId;
  final String userName;
  final String email;
  final UserRole role;
  final bool isActive;

  const SignupResponse({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      role: UserRole.fromString(json['roleName'] as String? ?? ''),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  User toDomain() {
    return User(userId: userId, userName: userName, email: email, role: role);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'roleName': role.name,
      'isActive': isActive,
    };
  }
}
