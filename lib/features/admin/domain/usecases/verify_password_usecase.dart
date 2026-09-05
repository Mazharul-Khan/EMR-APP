import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';

class VerifyPasswordUsecase {
  final AdminRepository repository;

  VerifyPasswordUsecase(this.repository);

  Future<bool> call({
    required String token,
    required String password,
  }) async {
    return await repository.verifyPassword(
      token: token,
      password: password,
    );
  }
}
