import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

/// DTO strictly mirroring Spring Boot's `UserSummaryResponse.java`
/// returned from `GET /admin/users/getAllUsers` and `PUT /admin/users/{userId}/status`.
class AdminUserModel {
  final String userId;
  final String userName;
  final String email;
  final String role;
  final bool active;
  final DateTime? createdAt;

  const AdminUserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.active,
    this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      userId: (json['userId'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      active: json['active'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  AdminUser toEntity() {
    return AdminUser(
      userId: userId,
      userName: userName,
      email: email,
      role: UserRole.fromString(role),
      isActive: active,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
