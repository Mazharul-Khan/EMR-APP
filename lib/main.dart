import 'package:emr_app/core/themes/app_colors.dart';
import 'package:emr_app/core/utils/app_bloc_observer.dart';
import 'package:emr_app/features/admin/domain/usecases/create_user_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/get_all_users_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/get_roles_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/toggle_user_status_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/verify_password_usecase.dart';
import 'package:emr_app/features/admin/infrastructure/adapters/admin_repository_impl.dart';
import 'package:emr_app/features/admin/infrastructure/datasources/admin_remote_datasource_impl.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_bloc.dart';
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

    final adminDatasource = AdminRemoteDatasourceImpl(apiClient);
    final adminRepository = AdminRepositoryImpl(adminDatasource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUsecase: LoginUsecase(authRepository),
            signupUsecase: SignupUsecase(authRepository),
            loginWithTokenUsecase: LoginWithTokenUsecase(authRepository),
            cachedTokenUsecase: GetCachedTokenUsecase(authRepository),
            logoutUsecase: LogoutUsecase(authRepository),
          ),
        ),
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(
            getAllUsersUsecase: GetAllUsersUsecase(adminRepository),
            toggleUserStatusUsecase: ToggleUserStatusUsecase(adminRepository),
            createUserUsecase: CreateUserUsecase(adminRepository),
            getRolesUsecase: GetRolesUsecase(adminRepository),
            verifyPasswordUsecase: VerifyPasswordUsecase(adminRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'EMR App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
