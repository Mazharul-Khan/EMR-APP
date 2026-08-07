import 'dart:core' show Future, String;

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken(String token);
}
