import 'package:emr_app/features/auth/domain/entities/user.dart';

class AdminUser {
  final String userId;
  final String userName;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime? createdAt;
  final String? createdBy;

  const AdminUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.createdBy,
  });

  AdminUser copyWith({
    String? userId,
    String? userName,
    String? email,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return AdminUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
