import 'package:dio/dio.dart';
import 'package:emr_app/core/network/api_client.dart';
import 'package:emr_app/features/admin/infrastructure/datasources/admin_remote_datasource.dart';
import 'package:emr_app/features/admin/infrastructure/models/admin_user_model.dart';
import 'package:emr_app/features/auth/infrastructure/models/signup_response.dart';

class AdminRemoteDatasourceImpl implements AdminRemoteDatasource {
  final ApiClient apiClient;

  AdminRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<AdminUserModel>> getAllUsers(String token) async {
    try {
      final response = await apiClient.dio.get('admin/users/getAllUsers');
      final dynamic body = response.data;
      List<dynamic> list = [];

      if (body is Map && body['data'] is List) {
        list = body['data'] as List;
      } else if (body is List) {
        list = body;
      }

      return list
          .map((item) => AdminUserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Failed to fetch users';
      throw Exception(errorMsg);
    }
  }

  @override
  Future<AdminUserModel> toggleUserStatus(
    String token,
    String userId,
    bool isActive,
  ) async {
    try {
      final response = await apiClient.dio.put(
        'admin/users/$userId/status',
        data: {'active': isActive},
      );

      final dynamic body = response.data;
      final Map<String, dynamic> data = (body is Map && (body['data'] is Map))
          ? body['data'] as Map<String, dynamic>
          : (body as Map<String, dynamic>);
      return AdminUserModel.fromJson(data);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.message ??
          'Failed to update status';
      throw Exception(errorMsg);
    }
  }

  @override
  Future<SignupResponse> createUser(
    String token,
    String userName,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await apiClient.dio.post(
        'auth/signup',
        data: {
          'userName': userName,
          'email': email,
          'password': password,
          'role': role,
        },
      );
      final dynamic body = response.data;
      final Map<String, dynamic> data = (body is Map && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : (body as Map<String, dynamic>);
      return SignupResponse.fromJson(data);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Failed to create user';
      throw Exception(errorMsg);
    }
  }
}
