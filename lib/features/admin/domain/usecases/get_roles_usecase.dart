import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';

class GetRolesUsecase {
  final AdminRepository repository;

  GetRolesUsecase(this.repository);

  Future<List<String>> call({required String token}) async {
    return await repository.getRoles(token: token);
  }
}
