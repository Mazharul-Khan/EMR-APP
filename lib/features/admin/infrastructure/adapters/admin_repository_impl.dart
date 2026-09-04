import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';
import 'package:emr_app/features/admin/infrastructure/datasources/admin_remote_datasource.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDatasource remoteDatasource;

  AdminRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<AdminUser>> getAllUsers({required String token}) async {
    final models = await remoteDatasource.getAllUsers(token);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AdminUser> toggleUserStatus({
    required String token,
    required String userId,
    required bool isActive,
  }) async {
    final model = await remoteDatasource.toggleUserStatus(
      token,
      userId,
      isActive,
    );
    return model.toEntity();
  }

  @override
  Future<AdminUser> createUser({
    required String token,
    required String userName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final response = await remoteDatasource.createUser(
      token,
      userName,
      email,
      password,
      role.name,
    );
    return AdminUser(
      userId: response.userId,
      userName: response.userName,
      email: response.email,
      role: UserRole.fromString(response.role),
      isActive: response.isActive,
      createdAt: DateTime.now(),
    );
  }
}
