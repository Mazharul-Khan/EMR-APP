import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class LoginWithTokenUsecase {
  final AuthRepository repository;

  LoginWithTokenUsecase(this.repository);

  Future<AuthSession> call(String token) {
    return repository.loginWithToken(token: token);
  }
}
