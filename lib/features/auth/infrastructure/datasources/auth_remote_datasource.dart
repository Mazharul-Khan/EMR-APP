import 'package:emr_app/features/auth/infrastructure/models/login_response.dart';
import 'package:emr_app/features/auth/infrastructure/models/signup_response.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponse> login(String userName, String password);

  Future<SignupResponse> signup(
    String userName,
    String password,
    String email,
    String role,
  );
  Future<String> logOut(String token);
  Future<LoginResponse> loginWithToken(String token);
}
