/// DTO directly mirroring Spring Boot's `SaveAuthTokenResponse.java` from `POST /auth/login`.
class LoginResponse {
  final String tokenId;
  final String userId;
  final String token;
  final DateTime? expiresAt;
  final bool active;

  const LoginResponse({
    required this.tokenId,
    required this.userId,
    required this.token,
    required this.expiresAt,
    required this.active,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> rawJson) {
    final data = rawJson['data'] is Map<String, dynamic>
        ? rawJson['data'] as Map<String, dynamic>
        : rawJson;

    return LoginResponse(
      tokenId: (data['tokenId'] ?? '').toString(),
      userId: (data['userId'] ?? '').toString(),
      token: (data['token'] ?? '').toString(),
      active: data['active'] as bool? ?? false,
      expiresAt: _parseTimestamp(data['expiresAt']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) {
      return value > 100000000000
          ? DateTime.fromMillisecondsSinceEpoch(value)
          : DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return null;
  }
}
