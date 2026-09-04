import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_local_datasource.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:emr_app/features/auth/infrastructure/models/validate_token_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl(this.remote, this.localDatasource);

  AuthSession _toSession(ValidateTokenResponse profile, String token) {
    return AuthSession(
      user: User(
        userId: profile.userId,
        userName: profile.userName,
        email: profile.email,
        role: UserRole.fromString(profile.roleName),
      ),
      token: token,
      expiresAt: profile.tokenExpiresAt,
    );
  }

  @override
  Future<AuthSession> loginWithUserNameAndPassword({
    required String userName,
    required String password,
    bool rememberMe = false,
  }) async {
    // 1. Authenticate with backend and obtain active token (SaveAuthTokenResponse)
    final loginResponse = await remote.login(userName, password);

    // 2. Fetch full user profile & role via validate endpoint (ValidateTokenResponse)
    final profileResponse = await remote.loginWithToken(loginResponse.token);

    if (rememberMe) {
      await localDatasource.cacheToken(loginResponse.token);
    } else {
      await localDatasource.clearToken(loginResponse.token);
    }

    return _toSession(profileResponse, loginResponse.token);
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
      role: UserRole.fromString(response.role),
    );
  }

  @override
  Future<String> logOut({required String token}) async {
    try {
      final response = await remote.logOut(token);
      return response.toString();
    } finally {
      await localDatasource.clearToken(token);
    }
  }

  @override
  Future<AuthSession> loginWithToken({required String token}) async {
    final profileResponse = await remote.loginWithToken(token);

    return _toSession(profileResponse, token);
  }

  @override
  Stream<User?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getCachedToken() {
    return localDatasource.getToken();
  }
}
