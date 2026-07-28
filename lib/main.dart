import 'package:emr_app/core/utils/app_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emr_app/core/network/api_client.dart';
import 'package:emr_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/login_with_token_usecase.dart';
import 'package:emr_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:emr_app/features/auth/infrastructure/adapters/auth_repository_impl.dart';
import 'package:emr_app/features/auth/infrastructure/datasources/auth_remote_datasource_impl.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emr_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiClient = ApiClient();
    final authDatasource = AuthRemoteDatasourceImpl(apiClient);
    final authRepository = AuthRepositoryImpl(authDatasource);

    return MaterialApp(
      title: 'EMR App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0062FF)),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          loginUsecase: LoginUsecase(authRepository),
          signupUsecase: SignupUsecase(authRepository),
          loginWithTokenUsecase: LoginWithTokenUsecase(authRepository),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}


