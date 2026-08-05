import 'dart:async';
import 'dart:core' show Future, String;

import 'package:emr_app/features/auth/infrastructure/models/login_response.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken(String token);
}
