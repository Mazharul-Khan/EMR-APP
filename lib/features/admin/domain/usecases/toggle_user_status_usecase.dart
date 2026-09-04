import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/ports/admin_repository.dart';

class ToggleUserStatusUsecase {
  final AdminRepository repository;

  const ToggleUserStatusUsecase(this.repository);

  Future<AdminUser> call({
    required String token,
    required String userId,
    required bool isActive,
  }) {
    return repository.toggleUserStatus(
      token: token,
      userId: userId,
      isActive: isActive,
    );
  }
}
