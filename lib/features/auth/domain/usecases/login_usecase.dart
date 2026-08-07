import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<AuthSession> call(String userName, String password, bool rememberMe) {
    return repository.loginWithUserNameAndPassword(
      userName: userName,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
