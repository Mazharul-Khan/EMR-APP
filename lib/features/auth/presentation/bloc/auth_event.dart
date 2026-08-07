abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String userName;
  final String password;
  final bool rememberMe;

  LoginSubmitted({
    required this.userName,
    required this.password,
    this.rememberMe = false,
  });
}

class SignupSubmitted extends AuthEvent {
  final String userName;
  final String password;
  final String email;
  final String role;

  SignupSubmitted({
    required this.userName,
    required this.password,
    required this.email,
    required this.role,
  });
}

class LoginWithTokenRequested extends AuthEvent {
  final String token;
  LoginWithTokenRequested({required this.token});
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
