import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';

class GetAllUsersUsecase {
  final AdminRepository repository;

  const GetAllUsersUsecase(this.repository);

  Future<List<AdminUser>> call({required String token}) {
    return repository.getAllUsers(token: token);
  }
}
