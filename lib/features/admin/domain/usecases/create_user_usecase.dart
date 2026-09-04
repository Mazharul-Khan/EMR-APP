import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

class CreateUserUsecase {
  final AdminRepository repository;

  const CreateUserUsecase(this.repository);

  Future<AdminUser> call({
    required String token,
    required String userName,
    required String email,
    required String password,
    required UserRole role,
  }) {
    return repository.createUser(
      token: token,
      userName: userName,
      email: email,
      password: password,
      role: role,
    );
  }
}
