import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  // Helper: converts a raw LoginResponse DTO into the domain AuthSession.
  // This mapping belongs here in the adapter — not inside the DTO.
  AuthSession _toSession(dynamic response) {
    return AuthSession(
      user: User(
        userId: response.userId,
        userName: response.userName,
        email: response.email,
        role: UserRole.fromString(response.role),
      ),
      token: response.token,
    );
  }

  @override
  Future<AuthSession> loginWithUserNameAndPassword({
    required String userName,
    required String password,
  }) async {
    final response = await remote.login(userName, password);

    return _toSession(response);
  }

  @override
  Future<User> signUpWithUserNameEmailPassword({
    required String userName,
    required String password,
    required String email,
    required String role,
  }) async {
    final response = await remote.signup(userName, password, email, role);

    return User(
      userId: response.userId,
      userName: response.userName,
      email: response.email,
      role: UserRole.fromString(response.role), // map raw String → domain enum here
    );
  }

  @override
  Future<String> logOut({required String token}) async {
    final response = await remote.logOut(token);

    return response.toString();
  }

  @override
  Future<AuthSession> loginWithToken({required String token}) async {
    final response = await remote.loginWithToken(token);

    return _toSession(response);
  }

  @override
  Stream<User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
