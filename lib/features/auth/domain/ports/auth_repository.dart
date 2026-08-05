import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Stream<User?> getCurrentUser();

  Future<AuthSession> loginWithUserNameAndPassword({
    required String userName,
    required String password,
  });

  Future<AuthSession> loginWithToken({required String token});

  Future<User> signUpWithUserNameEmailPassword({
    required String userName,
    required String password,
    required String email,
    required String role,
  });

  Future<String> logOut({required String token});

  Future<String?> getCachedToken();
}
