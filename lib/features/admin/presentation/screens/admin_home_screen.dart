import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emr_app/core/themes/app_colors.dart';
import 'package:emr_app/core/widgets/app_sidebar.dart';
import 'package:emr_app/core/widgets/app_stat_card.dart';
import 'package:emr_app/core/widgets/app_top_bar.dart';
import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_event.dart';
import 'package:emr_app/features/admin/presentation/bloc/admin_state.dart';
import 'package:emr_app/features/admin/presentation/widgets/admin_user_table.dart';
import 'package:emr_app/features/admin/presentation/widgets/create_user_drawer.dart';
import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:emr_app/features/auth/presentation/screens/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final AuthSession session;

  const AdminHomeScreen({super.key, required this.session});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavId = 'users';
  bool _isCreateDrawerOpen = false;
  Timer? _autoSyncTimer;

  final List<AppNavItem> _navItems = const [
    AppNavItem(
      id: 'overview',
      label: 'Overview',
      icon: Icons.dashboard_outlined,
    ),
    AppNavItem(
      id: 'users',
      label: 'User Directory',
      icon: Icons.people_alt_outlined,
    ),
    AppNavItem(
      id: 'roles',
      label: 'Roles & Access',
      icon: Icons.shield_outlined,
    ),
    AppNavItem(
      id: 'audit',
      label: 'Audit Logs',
      icon: Icons.history_edu_outlined,
    ),
    AppNavItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Fetch users and dynamic system roles
    context.read<AdminBloc>().add(
          FetchUsersEvent(token: widget.session.token),
        );
    // Background auto-sync every 5 minutes without disrupting UI
    _startAutoSyncTimer();
  }

  void _startAutoSyncTimer() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) {
        context.read<AdminBloc>().add(
              FetchUsersEvent(
                token: widget.session.token,
                isSilent: true,
              ),
            );
      }
    });
  }

  void _handleManualSync() {
    context.read<AdminBloc>().add(
          FetchUsersEvent(
            token: widget.session.token,
            isSilent: false,
          ),
        );
    // Reset the periodic timer so next auto-sync fires 5 min from manual click
    _startAutoSyncTimer();
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  void _handleLogout() {
    _autoSyncTimer?.cancel();
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _toggleCreateDrawer(bool open) {
    setState(() {
      _isCreateDrawerOpen = open;
    });
  }

  void _handleCreateUser({
    required String userName,
    required String email,
    required String password,
    required UserRole role,
  }) {
    context.read<AdminBloc>().add(
          CreateUserEvent(
            token: widget.session.token,
            userName: userName,
            email: email,
            password: password,
            role: role,
            createdBy: widget.session.user.userName,
          ),
        );
  }

  void _showSelfDeactivationNoticeAndLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Row(
            children: [
              Icon(
                Icons.lock_person_outlined,
                color: AppColors.errorRed,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Account Deactivated',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Your administrator account has been deactivated. In accordance with clinical security policy, you have been automatically logged out and your session token has been revoked.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textBody,
              height: 1.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('Return to Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is AdminLoaded) {
          // Detect if the currently logged-in administrator deactivated their own account
          final currentUserId = widget.session.user.userId;
          final currentUserName = widget.session.user.userName.toLowerCase();
          final selfAccount = state.users.where((u) {
            return (currentUserId.isNotEmpty && u.userId == currentUserId) ||
                u.userName.toLowerCase() == currentUserName;
          }).firstOrNull;

          if (selfAccount != null && !selfAccount.isActive) {
            _showSelfDeactivationNoticeAndLogout();
            return;
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.successGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Close drawer if open
            if (_isCreateDrawerOpen) {
              _toggleCreateDrawer(false);
            }
          }
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminLoading;
        final isActionLoading =
            state is AdminLoaded && state.isActionLoading;

        final users = state is AdminLoaded ? state.filteredUsers : <AdminUser>[];
        final roles = state is AdminLoaded ? state.roles : <String>[];
        final selectedRole =
            state is AdminLoaded ? state.selectedRole : 'All';
        final searchQuery =
            state is AdminLoaded ? state.searchQuery : '';

        final totalUsersCount =
            state is AdminLoaded ? state.totalUsers.toString() : '0';
        final doctorsCount =
            state is AdminLoaded ? state.totalDoctors.toString() : '0';
        final patientsCount =
            state is AdminLoaded ? state.totalPatients.toString() : '0';
        final disabledCount =
            state is AdminLoaded ? state.disabledUsers.toString() : '0';

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 960;

            final sidebarWidget = AppSidebar(
              items: _navItems,
              selectedId: _selectedNavId,
              systemTitle: 'Clinical EMR',
              systemSubtitle: 'Clinical Administration Console',
              onItemSelected: (id) {
                setState(() {
                  _selectedNavId = id;
                });
                if (!isDesktop) {
                  Navigator.of(context).pop(); // Close drawer on mobile
                }
              },
              onLogout: _handleLogout,
            );

            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppColors.dashboardCanvasBackground,
              drawer: isDesktop ? null : Drawer(child: sidebarWidget),
              body: Row(
                children: [
                  // Permanent left sidebar on desktop
                  if (isDesktop) sidebarWidget,

                  // Main Content Area
                  Expanded(
                    child: Column(
                      children: [
                        // Clinical Deep Blue Top Bar
                        AppTopBar(
                          title: 'User Directory',
                          subtitle: 'Manage healthcare personnel & patient accounts',
                          userName: widget.session.user.userName,
                          roleName: widget.session.user.role.name,
                          showMenuButton: !isDesktop,
                          onMenuPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          onSearchChanged: (q) {
                            context.read<AdminBloc>().add(SearchUsersEvent(q));
                          },
                          onLogoutPressed: _handleLogout,
                          onSyncPressed: _handleManualSync,
                          isSyncing: state is AdminLoaded && state.isSyncing,
                          lastSyncedAt:
                              state is AdminLoaded ? state.lastSyncedAt : null,
                        ),

                        // Scrollable Dashboard Body
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 4 Executive KPI Metric Cards
                                _buildKpiGrid(
                                  constraints: constraints,
                                  isLoading: isLoading,
                                  totalUsers: totalUsersCount,
                                  doctors: doctorsCount,
                                  patients: patientsCount,
                                  disabled: disabledCount,
                                ),

                                const SizedBox(height: 24),

                                // User Table / Management Card
                                AdminUserTable(
                                  users: users,
                                  availableRoles: roles,
                                  selectedRole: selectedRole,
                                  searchQuery: searchQuery,
                                  currentUserId: widget.session.user.userId,
                                  currentUserName: widget.session.user.userName,
                                  isLoading: isLoading,
                                  isActionLoading: isActionLoading,
                                  onRoleSelected: (role) {
                                    context
                                        .read<AdminBloc>()
                                        .add(FilterByRoleEvent(role));
                                  },
                                  onSearchChanged: (query) {
                                    context
                                        .read<AdminBloc>()
                                        .add(SearchUsersEvent(query));
                                  },
                                  onCreateUserPressed: () {
                                    if (isDesktop) {
                                      _toggleCreateDrawer(true);
                                    } else {
                                      _openMobileCreateSheet(roles, isActionLoading);
                                    }
                                  },
                                  onToggleStatus: (userId, newStatus) {
                                    context.read<AdminBloc>().add(
                                          ToggleUserStatusEvent(
                                            token: widget.session.token,
                                            userId: userId,
                                            isActive: newStatus,
                                          ),
                                        );
                                  },
                                  onVerifyPassword: (password) {
                                    return context
                                        .read<AdminBloc>()
                                        .verifyAdminPassword(
                                          token: widget.session.token,
                                          password: password,
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slide-out Drawer Panel on Desktop
                  if (isDesktop && _isCreateDrawerOpen)
                    CreateUserDrawer(
                      availableRoles: roles,
                      isLoading: isActionLoading,
                      onClose: () => _toggleCreateDrawer(false),
                      onCreateUser: _handleCreateUser,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKpiGrid({
    required BoxConstraints constraints,
    required bool isLoading,
    required String totalUsers,
    required String doctors,
    required String patients,
    required String disabled,
  }) {
    final width = constraints.maxWidth;

    final cards = [
      AppStatCard(
        title: 'Total Accounts',
        value: totalUsers,
        trend: 'System wide',
        isPositiveTrend: true,
        icon: Icons.people_alt_outlined,
        iconColor: AppColors.primaryBlue,
        iconBackgroundColor: AppColors.primaryBlueIce,
        backgroundGradient: const LinearGradient(
          colors: [
            AppColors.statCardBlueGradientStart,
            AppColors.statCardBlueGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: AppColors.statCardBlueBorder,
        isLoading: isLoading,
      ),
      AppStatCard(
        title: 'Medical Staff (Doctors)',
        value: doctors,
        trend: 'Clinical users',
        isPositiveTrend: true,
        icon: Icons.health_and_safety_outlined,
        iconColor: AppColors.roleDoctorIcon,
        iconBackgroundColor: AppColors.roleDoctorCardBg,
        backgroundGradient: const LinearGradient(
          colors: [
            AppColors.statCardDoctorGradientStart,
            AppColors.statCardDoctorGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: AppColors.statCardDoctorBorder,
        isLoading: isLoading,
      ),
      AppStatCard(
        title: 'Patients Registered',
        value: patients,
        trend: 'Patient portal',
        isPositiveTrend: true,
        icon: Icons.personal_injury_outlined,
        iconColor: AppColors.successGreen,
        iconBackgroundColor: AppColors.rolePatientCardBg,
        backgroundGradient: const LinearGradient(
          colors: [
            AppColors.statCardPatientGradientStart,
            AppColors.statCardPatientGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: AppColors.statCardPatientBorder,
        isLoading: isLoading,
      ),
      AppStatCard(
        title: 'Disabled Accounts',
        value: disabled,
        trend: 'Revoked access',
        isPositiveTrend: false,
        icon: Icons.block_outlined,
        iconColor: AppColors.errorRed,
        iconBackgroundColor: AppColors.errorRedSoftBg,
        backgroundGradient: const LinearGradient(
          colors: [
            AppColors.statCardDisabledGradientStart,
            AppColors.statCardDisabledGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderColor: AppColors.statCardDisabledBorder,
        isLoading: isLoading,
      ),
    ];

    if (width > 1200) {
      return Row(
        children: cards
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: card,
                ),
              ),
            )
            .toList(),
      );
    } else if (width > 700) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: cards[0],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: cards[1],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: cards[2],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: cards[3],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: card,
              ),
            )
            .toList(),
      );
    }
  }

  void _openMobileCreateSheet(List<String> roles, bool isLoading) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CreateUserDrawer(
          availableRoles: roles,
          isLoading: isLoading,
          onClose: () => Navigator.of(context).pop(),
          onCreateUser: ({
            required String userName,
            required String email,
            required String password,
            required UserRole role,
          }) {
            _handleCreateUser(
              userName: userName,
              email: email,
              password: password,
              role: role,
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
