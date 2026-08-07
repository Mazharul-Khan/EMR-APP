import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call(String token) async {
    await repository.logOut(token: token);
  }
}
