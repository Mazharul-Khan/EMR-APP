import 'package:emr_app/features/admin/infrastructure/models/admin_user_model.dart';
import 'package:emr_app/features/auth/infrastructure/models/signup_response.dart';

abstract class AdminRemoteDatasource {
  Future<List<AdminUserModel>> getAllUsers(String token);

  Future<AdminUserModel> toggleUserStatus(
    String token,
    String userId,
    bool isActive,
  );

  Future<SignupResponse> createUser(
    String token,
    String userName,
    String email,
    String password,
    String role, {
    String? createdBy,
  });

  Future<List<String>> getRoles(String token);

  Future<bool> verifyPassword(String token, String password);
}
