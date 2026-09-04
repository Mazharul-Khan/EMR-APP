import 'package:emr_app/features/auth/domain/entities/user.dart';

class AuthSession {
  final User user;
  final String token;
  final DateTime? expiresAt;

  const AuthSession({
    required this.user,
    required this.token,
    this.expiresAt,
  });

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
