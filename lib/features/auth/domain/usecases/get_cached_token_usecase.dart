import 'package:emr_app/features/auth/domain/ports/auth_repository.dart';

class GetCachedTokenUsecase {
  final AuthRepository repository;

  GetCachedTokenUsecase(this.repository);

  Future<String?> call() {
    return repository.getCachedToken();
  }
}
