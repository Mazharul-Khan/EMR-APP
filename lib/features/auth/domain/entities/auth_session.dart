import 'package:emr_app/features/auth/domain/entities/user.dart';

class AuthSession {
  final User user;
  final String token;

  const AuthSession({required this.user, required this.token});
}
