import 'package:emr_app/features/auth/infrastructure/datasources/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences _prefs;

  static const String _keyAuthToken = 'auth_token';
  // static const String _keyUserData = 'user_data';

  AuthLocalDatasourceImpl(this._prefs);

  @override
  Future<void> cacheToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_keyAuthToken);
  }

  @override
  Future<void> clearToken(String token) async {
    await _prefs.remove(_keyAuthToken);
  }
}
