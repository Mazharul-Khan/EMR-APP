import 'package:flutter/material.dart';
import 'package:emr_app/core/themes/app_colors.dart';

/// Reusable enterprise clinical top navigation bar.
/// Styled in deep clinical navy with glowing blue accents, search input,
/// user profile chip, and quick logout button.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final String userName;
  final String roleName;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSyncPressed;
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final bool showMenuButton;
  final String searchHint;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.userName,
    required this.roleName,
    this.onSearchChanged,
    this.onLogoutPressed,
    this.onMenuPressed,
    this.onSyncPressed,
    this.isSyncing = false,
    this.lastSyncedAt,
    this.showMenuButton = false,
    this.searchHint = 'Search...',
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.deepNavyBlue,
        border: Border(
          bottom: BorderSide(color: AppColors.navyBorderDivider, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            final isMedium = constraints.maxWidth > 650;

            return Row(
              children: [
                if (showMenuButton) ...[
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: onMenuPressed,
                  ),
                  const SizedBox(width: 8),
                ],

                // Section Title & Optional Subtitle
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (subtitle != null && isMedium)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),

                const Spacer(),

                // Top Search Bar (if callback provided and on wide screens)
                if (onSearchChanged != null && isWide)
                  Expanded(
                    flex: 2,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      child: TextField(
                        onChanged: onSearchChanged,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        cursorColor: AppColors.primaryBlue,
                        decoration: InputDecoration(
                          hintText: searchHint,
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: AppColors.navyCardBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.navyBorderSubtle,
                              width: 1,
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

                // Sync Button
                if (onSyncPressed != null) ...[
                  _SyncButton(
                    isSyncing: isSyncing,
                    onSyncPressed: onSyncPressed,
                    lastSyncedAt: lastSyncedAt,
                    compact: !isMedium,
                  ),
                  const SizedBox(width: 12),
                ],

                // Profile Avatar & Role Pill
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isMedium) ...[
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navyBorderSubtle,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              roleName.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryBlueLight,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(width: 16),

                // Logout Button
                if (isMedium)
                  OutlinedButton.icon(
                    onPressed: onLogoutPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.errorRed),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: AppColors.errorRed,
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  IconButton(
                    onPressed: onLogoutPressed,
                    tooltip: 'Logout',
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.errorRed,
                      size: 20,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SyncButton extends StatefulWidget {
  final bool isSyncing;
  final VoidCallback? onSyncPressed;
  final DateTime? lastSyncedAt;
  final bool compact;

  const _SyncButton({
    required this.isSyncing,
    required this.onSyncPressed,
    this.lastSyncedAt,
    this.compact = false,
  });

  @override
  State<_SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<_SyncButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isSyncing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _SyncButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSyncing && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isSyncing && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final tooltipText = widget.lastSyncedAt != null
        ? 'Sync Now (Last synced: ${_formatTime(widget.lastSyncedAt!)} • Auto-sync every 5 min)'
        : 'Sync Now (Auto-sync every 5 min)';

    return Tooltip(
      message: tooltipText,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.isSyncing ? null : widget.onSyncPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 38,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 10 : 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: widget.isSyncing
                  ? AppColors.syncButtonActiveBg
                  : AppColors.syncButtonBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.isSyncing
                    ? AppColors.primaryBlueLight
                    : AppColors.syncButtonBorder,
                width: 1,
              ),
              boxShadow: widget.isSyncing
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _controller,
                  child: Icon(
                    Icons.sync_rounded,
                    size: 16,
                    color: widget.isSyncing
                        ? AppColors.primaryBlueLight
                        : Colors.white,
                  ),
                ),
                if (!widget.compact) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.isSyncing ? 'Syncing...' : 'Sync',
                    style: TextStyle(
                      color: widget.isSyncing
                          ? AppColors.primaryBlueLight
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
