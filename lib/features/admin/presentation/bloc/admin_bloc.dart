import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/usecases/create_user_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/get_all_users_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/get_roles_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/toggle_user_status_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/verify_password_usecase.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_event.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAllUsersUsecase getAllUsersUsecase;
  final ToggleUserStatusUsecase toggleUserStatusUsecase;
  final CreateUserUsecase createUserUsecase;
  final GetRolesUsecase getRolesUsecase;
  final VerifyPasswordUsecase verifyPasswordUsecase;

  AdminBloc({
    required this.getAllUsersUsecase,
    required this.toggleUserStatusUsecase,
    required this.createUserUsecase,
    required this.getRolesUsecase,
    required this.verifyPasswordUsecase,
  }) : super(AdminInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
    on<CreateUserEvent>(_onCreateUser);
    on<SearchUsersEvent>(_onSearchUsers);
    on<FilterByRoleEvent>(_onFilterByRole);
  }

  Future<bool> verifyAdminPassword({
    required String token,
    required String password,
  }) async {
    return await verifyPasswordUsecase(token: token, password: password);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    final currentState = state;
    final isAlreadyLoaded = currentState is AdminLoaded;

    if (isAlreadyLoaded) {
      if (!event.isSilent) {
        emit(currentState.copyWith(isSyncing: true));
      }
    } else {
      emit(AdminLoading());
    }

    try {
      final users = await getAllUsersUsecase(token: event.token);

      List<String> roles = isAlreadyLoaded ? currentState.roles : [];
      try {
        roles = await getRolesUsecase(token: event.token);
      } catch (_) {
        if (roles.isEmpty) {
          // Graceful fallback if backend /roles endpoint is not yet loaded or restarted
          final userRoles = users.map((u) => u.role.name.toUpperCase()).toSet();
          roles = {'ADMIN', 'DOCTOR', 'PATIENT', ...userRoles}.toList();
        }
      }

      final currentQuery = isAlreadyLoaded ? currentState.searchQuery : '';
      final currentRole = isAlreadyLoaded ? currentState.selectedRole : 'All';
      final updatedFiltered = _filterList(users, currentQuery, currentRole);

      emit(AdminLoaded(
        users: users,
        filteredUsers: updatedFiltered,
        roles: roles,
        selectedRole: currentRole,
        searchQuery: currentQuery,
        isActionLoading: false,
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
        successMessage:
            event.isSilent ? null : 'Data synchronized successfully!',
      ));
    } catch (e) {
      if (isAlreadyLoaded) {
        emit(currentState.copyWith(
          isSyncing: false,
          errorMessage: event.isSilent
              ? null
              : 'Sync failed: ${e.toString().replaceAll('Exception: ', '')}',
        ));
      } else {
        emit(AdminError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> _onToggleUserStatus(
    ToggleUserStatusEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is! AdminLoaded) return;
    final currentState = state as AdminLoaded;

    emit(currentState.copyWith(isActionLoading: true));

    try {
      final updatedUser = await toggleUserStatusUsecase(
        token: event.token,
        userId: event.userId,
        isActive: event.isActive,
      );
      final updatedUsers = currentState.users.map((u) {
        return u.userId == updatedUser.userId ? updatedUser : u;
      }).toList();

      final updatedFiltered = _filterList(
        updatedUsers,
        currentState.searchQuery,
        currentState.selectedRole,
      );

      emit(
        currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
          isActionLoading: false,
          successMessage:
              'User "${updatedUser.userName}" status updated to ${updatedUser.isActive ? "Active" : "Disabled"}',
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isActionLoading: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onCreateUser(
    CreateUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    if (state is! AdminLoaded) return;
    final currentState = state as AdminLoaded;
    emit(currentState.copyWith(isActionLoading: true));
    try {
      final newUser = await createUserUsecase(
        token: event.token,
        userName: event.userName,
        email: event.email,
        password: event.password,
        role: event.role,
        createdBy: event.createdBy,
      );

      final updatedUsers = [newUser, ...currentState.users];
      final updatedFiltered = _filterList(
        updatedUsers,
        currentState.searchQuery,
        currentState.selectedRole,
      );
      emit(
        currentState.copyWith(
          users: updatedUsers,
          filteredUsers: updatedFiltered,
          isActionLoading: false,
          successMessage:
              'User "${newUser.userName}" (${newUser.role.name}) created successfully!',
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isActionLoading: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _onSearchUsers(SearchUsersEvent event, Emitter<AdminState> emit) {
    if (state is! AdminLoaded) return;
    final currentState = state as AdminLoaded;
    final filtered = _filterList(
      currentState.users,
      event.query,
      currentState.selectedRole,
    );
    emit(
      currentState.copyWith(searchQuery: event.query, filteredUsers: filtered),
    );
  }

  void _onFilterByRole(FilterByRoleEvent event, Emitter<AdminState> emit) {
    if (state is! AdminLoaded) return;
    final currentState = state as AdminLoaded;
    final filtered = _filterList(
      currentState.users,
      currentState.searchQuery,
      event.role,
    );
    emit(
      currentState.copyWith(selectedRole: event.role, filteredUsers: filtered),
    );
  }

  List<AdminUser> _filterList(
    List<AdminUser> users,
    String query,
    String selectedRole,
  ) {
    var result = users;

    if (selectedRole != 'All' && selectedRole.trim().isNotEmpty) {
      result = result.where((user) {
        return user.role.name.toLowerCase() == selectedRole.toLowerCase();
      }).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((user) {
        return user.userName.toLowerCase().contains(q) ||
            user.email.toLowerCase().contains(q) ||
            user.role.name.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }
}
