import 'package:emr_app/features/auth/domain/entities/user.dart';

abstract class AdminEvent {
  const AdminEvent();
}

class FetchUsersEvent extends AdminEvent {
  final String token;

  const FetchUsersEvent({required this.token});
}

class ToggleUserStatusEvent extends AdminEvent {
  final String token;
  final String userId;
  final bool isActive;

  const ToggleUserStatusEvent({
    required this.token,
    required this.userId,
    required this.isActive,
  });
}

class CreateUserEvent extends AdminEvent {
  final String token;
  final String userName;
  final String email;
  final String password;
  final UserRole role;

  const CreateUserEvent({
    required this.token,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
  });
}

class SearchUsersEvent extends AdminEvent {
  final String query;
  const SearchUsersEvent(this.query);
}
