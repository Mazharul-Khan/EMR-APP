import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

class AdminUserModel {
  final String userId;
  final String userName;
  final String email;
  final String role;
  final bool isActive;
  final String? createdAt;

  const AdminUserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.isActive,
    this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'Unknown',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
    );
  }
  AdminUser toEntity() {
    return AdminUser(
      userId: userId,
      userName: userName,
      email: email,
      role: UserRole.fromString(role),
      isActive: isActive,
      createdAt: createdAt != null
          ? DateTime.tryParse(createdAt!)
          : DateTime.now(),
    );
  }
}
