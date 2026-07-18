import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Logged in successfully
class AuthSuccess extends AuthState {
  final AuthSession session;
  AuthSuccess({required this.session});
}

/// Signed up successfully (Screen displays: "Signup Successful! Please Login")
class SignUpSuccess extends AuthState {
  final User user;
  SignUpSuccess({required this.user});
}

/// Something failed
class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
}
