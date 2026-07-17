import 'package:emr_app/features/auth/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:emr_app/features/auth/infrastructure/models/login_response.dart';
import 'package:emr_app/features/auth/infrastructure/models/signup_response.dart';
import 'package:emr_app/features/auth/infrastructure/services/api_client.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient api;

  AuthRemoteDatasourceImpl(this.api);

  @override
  Future<LoginResponse> login(String userName, String password) async {
    final response = await api.dio.post(
      "auth/login",
      data: {"userName": userName, "password": password},
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<SignupResponse> signup(
    String userName,
    String password,
    String email,
    String role,
  ) async {
    final response = await api.dio.post(
      "auth/signup",
      data: {
        "userName": userName,
        "password": password,
        "email": email,
        "role": role,
      },
    );
    return SignupResponse.fromJson(response.data);
  }

  @override
  Future<String> logOut(String token) async {
    final response = await api.dio.post("auth/logout", data: {"token": token});
    return response.data.toString();
  }

  @override
  Future<LoginResponse> loginWithToken(String token) async {
    final response = await api.dio.post(
      "auth/validate",
      data: {"token": token},
    );
    return LoginResponse.fromJson(response.data);
  }
}
