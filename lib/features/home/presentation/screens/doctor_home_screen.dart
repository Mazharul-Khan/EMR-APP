import 'package:emr_app/core/themes/app_colors.dart';
import 'package:emr_app/features/auth/domain/entities/auth_session.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorHomeScreen extends StatelessWidget {
  final AuthSession session;

  const DoctorHomeScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final user = session.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundGradientIceBlue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.local_hospital, color: AppColors.brightBlue),
            ),
            const SizedBox(width: 10),
            const Text(
              'Doctor Workspace',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavyBlue,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: AppColors.errorRedDark),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brightBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 48,
                  color: AppColors.brightBlue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome, Dr. ${user.userName}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavyBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: const TextStyle(fontSize: 14, color: AppColors.gray),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.roleDoctorIndigoBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ROLE: DOCTOR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.roleDoctorIndigo,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Doctor Clinical Workspace (Appointments, Vitals, Consultations) will be implemented here next.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGrayShade,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
