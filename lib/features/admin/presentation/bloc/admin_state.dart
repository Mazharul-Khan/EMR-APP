import 'package:emr_app/features/admin/domain/entities/admin_user.dart';

abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<AdminUser> users;
  final List<AdminUser> filteredUsers;
  final List<String> roles;
  final String selectedRole;
  final String searchQuery;
  final bool isActionLoading;
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? successMessage;
  final String? errorMessage;

  const AdminLoaded({
    required this.users,
    required this.filteredUsers,
    this.roles = const [],
    this.selectedRole = 'All',
    this.searchQuery = '',
    this.isActionLoading = false,
    this.isSyncing = false,
    this.lastSyncedAt,
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
    List<String>? roles,
    String? selectedRole,
    String? searchQuery,
    bool? isActionLoading,
    bool? isSyncing,
    DateTime? lastSyncedAt,
    String? successMessage,
    String? errorMessage,
  }) {
    return AdminLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      roles: roles ?? this.roles,
      selectedRole: selectedRole ?? this.selectedRole,
      searchQuery: searchQuery ?? this.searchQuery,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);
}
