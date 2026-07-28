// LoginResponse is a pure Data Transfer Object (DTO).
// Its only job is to hold the raw data that the API returned.
// It does NOT know anything about the domain. No domain imports.
// The adapter (AuthRepositoryImpl) is responsible for converting this to a domain object.
class LoginResponse {
  final String userId;
  final String userName;
  final String email;
  final String role; // raw string from API, e.g. "doctor", "patient", "admin"
  final String token;
  final bool isActive;

  const LoginResponse({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.token,
    required this.isActive,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> rawJson) {
    // Handle nested payload if API wraps data under 'data' or 'result' key
    final json = (rawJson.containsKey('data') && rawJson['data'] is Map<String, dynamic>)
        ? rawJson['data'] as Map<String, dynamic>
        : (rawJson.containsKey('result') && rawJson['result'] is Map<String, dynamic>)
            ? rawJson['result'] as Map<String, dynamic>
            : rawJson;

    return LoginResponse(
      userId: (json['userId'] ?? json['id'] ?? '').toString(),
      userName: (json['userName'] ?? json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['roleName'] ?? json['role'] ?? '').toString(),
      token: (json['token'] ?? json['accessToken'] ?? json['jwt'] ?? '').toString(),
      isActive: json['isActive'] is bool
          ? json['isActive'] as bool
          : (json['isActive']?.toString().toLowerCase() == 'true'),
    );
  }
}
