import 'package:flutter/material.dart';
import 'package:emr_app/core/themes/app_colors.dart';
import 'package:emr_app/core/widgets/app_shimmer.dart';
import 'package:emr_app/features/admin/domain/entities/admin_user.dart';
import 'package:emr_app/features/auth/domain/entities/user.dart';

/// Interactive user directory table with dynamic role chips,
/// live search, active/disabled toggles, and skeleton shimmer states.
class AdminUserTable extends StatelessWidget {
  final List<AdminUser> users;
  final List<String> availableRoles;
  final String selectedRole;
  final String searchQuery;
  final String? currentUserId;
  final String? currentUserName;
  final bool isLoading;
  final bool isActionLoading;
  final ValueChanged<String> onRoleSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreateUserPressed;
  final void Function(String userId, bool newStatus) onToggleStatus;
  final Future<bool> Function(String password)? onVerifyPassword;

  const AdminUserTable({
    super.key,
    required this.users,
    required this.availableRoles,
    required this.selectedRole,
    required this.searchQuery,
    this.currentUserId,
    this.currentUserName,
    required this.isLoading,
    required this.isActionLoading,
    required this.onRoleSelected,
    required this.onSearchChanged,
    required this.onCreateUserPressed,
    required this.onToggleStatus,
    this.onVerifyPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCardDark,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar: Search + Role Filter Chips + Create Button
          _buildToolbar(context),

          const Divider(color: AppColors.dividerLight, height: 1),

          // Table / List Content
          if (isLoading)
            _buildShimmerTable()
          else if (users.isEmpty)
            _buildEmptyState()
          else
            _buildTableContent(context),

          const Divider(color: AppColors.dividerLight, height: 1),

          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${users.length} user${users.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isActionLoading)
                  const Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Updating...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    // Dynamic roles list with 'All' as first chip
    final allRoles = ['All', ...availableRoles];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Search Field
              Expanded(
                child: Container(
                  height: 42,
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: TextField(
                    onChanged: onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search by username, email, or role...',
                      hintStyle: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      filled: true,
                      fillColor: AppColors.cardSurfaceLight,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.borderLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Create User Button
              ElevatedButton.icon(
                onPressed: onCreateUserPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'New User',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Role Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allRoles.map((role) {
                final isSelected =
                    selectedRole.toLowerCase() == role.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      role == 'All'
                          ? 'All Users'
                          : _capitalize(role),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textBody,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.deepNavyBlue,
                    backgroundColor: AppColors.dividerLight,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    onSelected: (_) => onRoleSelected(role),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 750;

        if (!isWide) {
          // Compact Card List for narrow screens
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.dividerLight, height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final isCurrent = _isCurrentUser(user);
              return Container(
                color:
                    isCurrent ? AppColors.currentUserRowBg : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildAvatar(user),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.userName,
                                  style: TextStyle(
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 14,
                                    color: isCurrent
                                        ? AppColors.primaryBlueDark
                                        : AppColors.textDark,
                                  ),
                                ),
                                if (isCurrent) ...[
                                  const SizedBox(width: 8),
                                  _buildCurrentUserBadge(),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRoleBadge(user.role.name),
                            const SizedBox(height: 4),
                            Text(
                              'Created ${_formatDate(user.createdAt)} by ${user.createdBy != null && user.createdBy!.isNotEmpty ? user.createdBy : "System"}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: user.isActive,
                        activeThumbColor: AppColors.successGreen,
                        onChanged: (val) =>
                            _showConfirmStatusDialog(context, user, val),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        // Desktop Table Layout
        return Table(
          columnWidths: const {
            0: FlexColumnWidth(2.4),
            1: FlexColumnWidth(2.8),
            2: FlexColumnWidth(1.6),
            3: FlexColumnWidth(1.8),
            4: FlexColumnWidth(2.2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: AppColors.cardSurfaceLight,
              ),
              children: [
                _buildHeaderCell('USER'),
                _buildHeaderCell('EMAIL'),
                _buildHeaderCell('ROLE'),
                _buildHeaderCell('STATUS'),
                _buildHeaderCell('CREATED / BY'),
              ],
            ),

            // Data Rows
            ...users.map((user) {
              final isCurrent = _isCurrentUser(user);
              return TableRow(
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.currentUserRowBg
                      : Colors.transparent,
                  border: Border(
                    bottom: const BorderSide(color: AppColors.dividerLight),
                    left: isCurrent
                        ? const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 3,
                          )
                        : BorderSide.none,
                  ),
                ),
                children: [
                  // User
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        _buildAvatar(user),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.userName,
                                  style: TextStyle(
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 13,
                                    color: isCurrent
                                        ? AppColors.primaryBlueDark
                                        : AppColors.textDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrent) ...[
                                const SizedBox(width: 8),
                                _buildCurrentUserBadge(),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Email
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textBody,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Role
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildRoleBadge(user.role.name),
                    ),
                  ),

                  // Status with Switch
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: user.isActive
                                ? AppColors.successGreenSoftBg
                                : AppColors.dividerLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user.isActive ? 'Active' : 'Disabled',
                            style: TextStyle(
                              color: user.isActive
                                  ? AppColors.successGreenDark
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: user.isActive,
                            activeThumbColor: AppColors.successGreen,
                            inactiveTrackColor: AppColors.borderLight,
                            onChanged: (val) =>
                                _showConfirmStatusDialog(context, user, val),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Created Date & Creator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDate(user.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'by ',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                user.createdBy != null && user.createdBy!.isNotEmpty
                                    ? user.createdBy!
                                    : 'System',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  bool _isCurrentUser(AdminUser user) {
    if (currentUserId != null &&
        currentUserId!.isNotEmpty &&
        user.userId == currentUserId) {
      return true;
    }
    if (currentUserName != null &&
        currentUserName!.isNotEmpty &&
        user.userName.toLowerCase() == currentUserName!.toLowerCase()) {
      return true;
    }
    return false;
  }

  Widget _buildCurrentUserBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.currentUserBadgeBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.currentUserBadgeBorder),
      ),
      child: const Text(
        'YOU',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.currentUserBadgeText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAvatar(AdminUser user) {
    Color bg;
    Color fg;
    final r = user.role.name.toLowerCase();

    if (r == 'admin') {
      // Admin: Dark color
      bg = AppColors.roleAdminDarkBg;
      fg = AppColors.roleAdminDarkText;
    } else if (r == 'doctor') {
      // Doctor: Less dark / Medium color
      bg = AppColors.roleDoctorMediumBg;
      fg = AppColors.roleDoctorMediumText;
    } else if (r == 'patient') {
      // Patient: Light color
      bg = AppColors.rolePatientLightBg;
      fg = AppColors.rolePatientLightText;
    } else {
      bg = AppColors.avatarIndigoBg;
      fg = AppColors.avatarIndigoText;
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: bg,
      child: Text(
        user.userName.isNotEmpty ? user.userName[0].toUpperCase() : 'U',
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color fg;
    BorderSide border;
    final r = role.toLowerCase();

    if (r == 'admin') {
      // Admin: Dark color
      bg = AppColors.roleAdminDarkBg;
      fg = AppColors.roleAdminDarkText;
      border = const BorderSide(color: AppColors.roleAdminDarkBorder, width: 1);
    } else if (r == 'doctor') {
      // Doctor: Less dark / Medium color
      bg = AppColors.roleDoctorMediumBg;
      fg = AppColors.roleDoctorMediumText;
      border =
          const BorderSide(color: AppColors.roleDoctorMediumBorder, width: 1);
    } else if (r == 'patient') {
      // Patient: Light color
      bg = AppColors.rolePatientLightBg;
      fg = AppColors.rolePatientLightText;
      border =
          const BorderSide(color: AppColors.rolePatientLightBorder, width: 1);
    } else {
      bg = AppColors.cardSurfaceLight;
      fg = AppColors.textBody;
      border = const BorderSide(color: AppColors.borderLight, width: 1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.fromBorderSide(border),
      ),
      child: Text(
        _capitalize(role),
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  void _showSoleAdminBlockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          title: const Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: AppColors.errorRed,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Action Blocked: Sole Administrator',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You cannot deactivate your own account because you are currently the only active administrator in the system.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textBody,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmberBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warningAmberBorder),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.warningAmberDark,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'System Requirement: To prevent permanent lockout of clinical workspace management, at least one other active administrator account must exist before you can deactivate this account.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warningAmberDark,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Understood',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmStatusDialog(
    BuildContext context,
    AdminUser user,
    bool newStatus,
  ) {
    final isActivating = newStatus;
    final isSelf = _isCurrentUser(user);

    // Sole Administrator Protection:
    // If the admin is deactivating their own account, ensure at least one other active admin exists.
    if (!isActivating && isSelf && user.role == UserRole.admin) {
      final otherActiveAdmins = users.where((u) {
        return u.isActive &&
            u.role == UserRole.admin &&
            !_isCurrentUser(u);
      }).length;

      if (otherActiveAdmins == 0) {
        _showSoleAdminBlockedDialog(context);
        return;
      }
    }

    final passwordController = TextEditingController();
    bool isObscured = true;
    bool isVerifying = false;
    String? validationError;

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isActivating
                          ? AppColors.successGreenSoftBg
                          : AppColors.errorRedSoftBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isActivating
                          ? Icons.check_circle_outline_rounded
                          : Icons.warning_amber_rounded,
                      color: isActivating
                          ? AppColors.successGreenDark
                          : AppColors.errorRedDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isActivating
                          ? 'Activate User Account'
                          : 'Deactivate User Account',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Are you sure you want to ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textBody,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: isActivating ? 'activate' : 'deactivate',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isActivating
                                  ? AppColors.successGreenDark
                                  : AppColors.errorRedDark,
                            ),
                          ),
                          const TextSpan(text: ' the account for '),
                          TextSpan(
                            text: user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          TextSpan(
                            text: isActivating
                                ? '?\n\nThis user will regain access to log in and use the EMR workspace.'
                                : '?\n\nThis user will be immediately blocked from logging into the EMR system.',
                          ),
                        ],
                      ),
                    ),
                    if (isSelf && !isActivating) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warningAmberBg,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppColors.warningAmberBorder),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: AppColors.warningAmberDark,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'High Alert: You are deactivating your own administrator account! Once confirmed, you will be automatically logged out immediately and your active session will be revoked.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warningAmberDark,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    const Text(
                      'Confirm Administrator Password',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: isObscured,
                      enabled: !isVerifying,
                      decoration: InputDecoration(
                        hintText: 'Enter your password to authorize',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.cardSurfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    if (validationError != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.errorRed, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              validationError!,
                              style: const TextStyle(
                                color: AppColors.errorRed,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: isVerifying
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          final pwd = passwordController.text.trim();
                          if (pwd.isEmpty) {
                            setDialogState(() {
                              validationError =
                                  'Password is required to confirm this action.';
                            });
                            return;
                          }

                          if (onVerifyPassword != null) {
                            setDialogState(() {
                              isVerifying = true;
                              validationError = null;
                            });

                            try {
                              final isValid = await onVerifyPassword!(pwd);
                              if (!dialogContext.mounted) return;
                              if (isValid) {
                                Navigator.of(dialogContext).pop(true);
                                onToggleStatus(user.userId, newStatus);
                              } else {
                                setDialogState(() {
                                  isVerifying = false;
                                  validationError =
                                      'Incorrect password. Verification failed.';
                                });
                              }
                            } catch (e) {
                              setDialogState(() {
                                isVerifying = false;
                                validationError = e
                                    .toString()
                                    .replaceAll('Exception: ', '');
                              });
                            }
                          } else {
                            Navigator.of(dialogContext).pop(true);
                            onToggleStatus(user.userId, newStatus);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActivating
                        ? AppColors.successGreen
                        : AppColors.errorRed,
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
                  child: isVerifying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isActivating
                              ? 'Activate Account'
                              : 'Deactivate Account',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerTable() {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.people_outline,
                color: AppColors.textMuted,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No users found',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkStaleBlue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try changing your search terms or filter selection.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
