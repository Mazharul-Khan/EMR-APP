import 'package:emr_app/features/admin/domain/entities/admin_user.dart';

abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<AdminUser> users;
  final List<AdminUser> filteredUsers;
  final String searchQuery;
  final bool isActionLoading;
  final String? successMessage;
  final String? errorMessage;

  const AdminLoaded({
    required this.users,
    required this.filteredUsers,
    this.searchQuery = '',
    this.isActionLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  int get totalUsers => users.length;
  int get activeUsers => users.where((u) => u.isActive).length;
  int get disabledUsers => users.where((u) => !u.isActive).length;
  int get totalDoctors =>
      users.where((u) => u.role.name.toLowerCase() == 'doctor').length;
  int get totalPatients =>
      users.where((u) => u.role.name.toLowerCase() == 'patient').length;

  AdminLoaded copyWith({
    List<AdminUser>? users,
    List<AdminUser>? filteredUsers,
    String? searchQuery,
    bool? isActionLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return AdminLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
}
