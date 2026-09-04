import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

abstract class AdminRepository {
  Future<List<AdminUser>> getAllUsers({required String token});

  Future<AdminUser> toggleUserStatus({
    required String token,
    required String userId,
    required bool isActive,
  });

  Future<AdminUser> createUser({
    required String token,
    required String userName,
    required String email,
    required String password,
    required UserRole role,
  });
}
