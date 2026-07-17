import 'package:emr_app/features/auth/domain/entities/user.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<User> call(
    String userName,
    String password,
    String email,
    String role,
  ) {
    return repository.signUpWithUserNameEmailPassword(
      userName: userName,
      password: password,
      email: email,
      role: role,
    );
  }
}
