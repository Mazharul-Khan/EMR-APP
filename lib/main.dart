import 'package:emr_app/core/utils/app_bloc_observer.dart';
import 'package:emr_app/features/auth/domain/usecases/get_cached_token_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_local_datasource_impl.dart';
import 'package:emr_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emr_app/core/network/api_client.dart';
import 'package:emr_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/login_with_token_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:emr_app/features/auth/infrastructure/adapters/auth_repository_impl.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_remote_datasource_impl.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiClient = ApiClient();
    final authDatasource = AuthRemoteDatasourceImpl(apiClient);
    final localDatasource = AuthLocalDatasourceImpl(sharedPreferences);
    final authRepository = AuthRepositoryImpl(authDatasource, localDatasource);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        loginUsecase: LoginUsecase(authRepository),
        signupUsecase: SignupUsecase(authRepository),
        loginWithTokenUsecase: LoginWithTokenUsecase(authRepository),
        cachedTokenUsecase: GetCachedTokenUsecase(authRepository),
        logoutUsecase: LogoutUsecase(authRepository),
      ),
      child: MaterialApp(
        title: 'EMR App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0062FF)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
