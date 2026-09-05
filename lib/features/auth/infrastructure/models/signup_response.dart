/// DTO directly mirroring Spring Boot's `SignUpResponse.java` from `POST /auth/signup`.
class SignupResponse {
  final String userId;
  final String userName;
  final String email;
  final String role; // mapped from backend roleName
  final bool isActive;
  final String? createdBy;

  const SignupResponse({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
    required this.isActive,
    this.createdBy,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> rawJson) {
    final data = rawJson['data'] is Map<String, dynamic>
        ? rawJson['data'] as Map<String, dynamic>
        : rawJson;

    return SignupResponse(
      userId: (data['userId'] ?? '').toString(),
      userName: (data['userName'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      role: (data['roleName'] ?? '').toString(),
      isActive: data['active'] as bool? ?? false,
      createdBy: data['createdBy']?.toString(),
    );
  }
}
