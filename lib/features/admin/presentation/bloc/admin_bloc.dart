import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/domain/usecases/create_user_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/get_all_users_usecase.dart';
import 'package:emr_app/features/admin/domain/usecases/toggle_user_status_usecase.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_event.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAllUsersUsecase getAllUsersUsecase;
  final ToggleUserStatusUsecase toggleUserStatusUsecase;
  final CreateUserUsecase createUserUsecase;

  AdminBloc({
    required this.getAllUsersUsecase,
    required this.toggleUserStatusUsecase,
    required this.createUserUsecase,
  }) : super(AdminInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
    on<CreateUserEvent>(_onCreateUser);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final users = await getAllUsersUsecase(token: event.token);
      emit(AdminLoaded(users: users, filteredUsers: users));
    } catch (e) {
      emit(AdminError(e.toString().replaceAll('Exception: ', '')));
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
      );

      final updatedUsers = [newUser, ...currentState.users];
      final updatedFiltered = _filterList(
        updatedUsers,
        currentState.searchQuery,
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
    final filtered = _filterList(currentState.users, event.query);
    emit(
      currentState.copyWith(searchQuery: event.query, filteredUsers: filtered),
    );
  }

  List<AdminUser> _filterList(List<AdminUser> users, String query) {
    if (query.trim().isEmpty) return users;
    final q = query.toLowerCase().trim();
    return users.where((user) {
      return user.userName.toLowerCase().contains(q) ||
          user.email.toLowerCase().contains(q) ||
          user.role.name.toLowerCase().contains(q);
    }).toList();
  }
}
