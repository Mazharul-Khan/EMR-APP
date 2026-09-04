/// DTO directly mirroring Spring Boot's `ValidateTokenResponse.java` from `POST /auth/validate`.
class ValidateTokenResponse {
  final String userId;
  final String userName;
  final String email;
  final String roleName;
  final bool active;
  final DateTime? tokenExpiresAt;

  const ValidateTokenResponse({
    required this.userId,
    required this.userName,
    required this.email,
    required this.roleName,
    required this.active,
    this.tokenExpiresAt,
  });

  factory ValidateTokenResponse.fromJson(Map<String, dynamic> rawJson) {
    final data = rawJson['data'] is Map<String, dynamic>
        ? rawJson['data'] as Map<String, dynamic>
        : rawJson;

    return ValidateTokenResponse(
      userId: (data['userId'] ?? '').toString(),
      userName: (data['userName'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      roleName: (data['roleName'] ?? '').toString(),
      active: data['active'] as bool? ?? false,
      tokenExpiresAt: data['tokenExpiresAt'] != null
          ? DateTime.tryParse(data['tokenExpiresAt'].toString())
          : null,
    );
  }
}
