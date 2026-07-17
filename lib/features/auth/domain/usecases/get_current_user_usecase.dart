import 'package:emr_app/features/auth/domain/entities/user.dart';
import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Stream<User?> call() {
    return repository.getCurrentUser();
  }
}
