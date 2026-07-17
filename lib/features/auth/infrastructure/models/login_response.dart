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

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      role: json['roleName'] as String? ?? '',
      token: json['token'] as String,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
