import 'package:emr_app/features/admin/infrastructure/models/admin_user_model.dart';

abstract class AdminRemoteDatasource {
  Future<List<AdminUserModel>> getAllUsers(String token);

  Future<AdminUserModel> toggleUserStatus(
    String token,
    String userId,
    bool isActive,
  );

  Future<AdminUserModel> createUser(
    String token,
    String userName,
    String email,
    String password,
    String role,
  );
}
