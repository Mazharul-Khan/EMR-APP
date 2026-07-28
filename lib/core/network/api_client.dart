import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio dio;

  /// Helper to get appropriate default Base URL depending on platform.
  /// On Android Emulator, '10.0.2.2' refers to localhost on the host machine.
  /// On Web/Windows/macOS/iOS, 'localhost' refers to localhost on the machine.
  static String defaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080/';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/';
    }
    return 'http://localhost:8080/';
  }

  ApiClient({String? baseUrl}) {
    final url = baseUrl ?? defaultBaseUrl();
    dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Attach LogInterceptor so ALL API requests, headers, bodies, responses, and errors
    // are automatically printed in the debug console.
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (object) {
          debugPrint('🌐 [API] $object');
        },
      ),
    );
  }
}

