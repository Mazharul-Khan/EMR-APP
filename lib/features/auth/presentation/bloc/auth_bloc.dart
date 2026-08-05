import 'package:dio/dio.dart';
import 'package:emr_app/features/auth/domain/usecases/get_cached_token_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:emr_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/login_with_token_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final LoginWithTokenUsecase _loginWithTokenUsecase;
  final GetCachedTokenUsecase _getCachedTokenUsecase;

  AuthBloc({
    required LoginUsecase loginUsecase,
    required SignupUsecase signupUsecase,
    required LoginWithTokenUsecase loginWithTokenUsecase,
    required GetCachedTokenUsecase cachedTokenUsecase,
  }) : _loginUsecase = loginUsecase,
       _signupUsecase = signupUsecase,
       _loginWithTokenUsecase = loginWithTokenUsecase,
       _getCachedTokenUsecase = cachedTokenUsecase,
       super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LoginWithTokenRequested>(_onLoginWithTokenRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_checkAuthStatus);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final session = await _loginUsecase.call(event.userName, event.password);
      emit(AuthSuccess(session: session));
    } catch (e, stackTrace) {
      debugPrint('❌ [AUTH BLOC ERROR] Login Exception: $e');
      debugPrint('📜 [STACK TRACE] $stackTrace');
      emit(AuthFailure(errorMessage: _parseErrorMessage(e)));
    }
  }

  String _parseErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
        return 'Server Error (${error.response?.statusCode}): ${error.response?.statusMessage ?? data}';
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Connection timeout. Please check your backend server.';
      } else if (error.type == DioExceptionType.connectionError) {
        return 'Cannot connect to backend server. Ensure backend is running and URL is reachable.';
      }
      return 'Network error: ${error.message}';
    }
    return error.toString();
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _signupUsecase.call(
        event.userName,
        event.password,
        event.email,
        event.role,
      );
      emit(SignUpSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoginWithTokenRequested(
    LoginWithTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final session = await _loginWithTokenUsecase.call(event.token);
      emit(AuthSuccess(session: session));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authToken = await _getCachedTokenUsecase.call();
      if (authToken == null || authToken.isEmpty) {
        emit(AuthInitial());
        return;
      }
      final session = await _loginWithTokenUsecase.call(authToken);
      emit(AuthSuccess(session: session));
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
