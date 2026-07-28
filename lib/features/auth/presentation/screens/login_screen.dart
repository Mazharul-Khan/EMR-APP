import 'package:emr_app/core/themes/app_colors.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:emr_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _usernameContoller = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obsecurePassword = true;

  @override
  void dispose() {
    _usernameContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    debugPrint(
      '🔘 [UI] Sign In button clicked for user: "${_usernameContoller.text.trim()}"',
    );
    if (_formkey.currentState?.validate() ?? false) {
      debugPrint(
        '🔘 [UI] Form validation succeeded. Dispatching LoginSubmitted event...',
      );
      context.read<AuthBloc>().add(
        LoginSubmitted(
          userName: _usernameContoller.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      debugPrint('⚠️ [UI] Form validation failed. Missing required fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundGradientIceBlue,
              AppColors.backgroundGradientColoudBlue,
            ],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.fitWidth,
            opacity: .45,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    return Center(
                      child: Container(
                        width: 1200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isDesktop)
                              Expanded(flex: 5, child: _buildLeftHeroSection()),
                            if (isDesktop) const SizedBox(width: 48),

                            Expanded(
                              flex: 5,
                              child: _buildLoginFormCard(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              _buildFooterBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftHeroSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EMR',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepNavyBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Electronic Medical Record',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 48),

        Text(
          'Smarter Care.\nBetter Outcome.',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.deepNavyBlue,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Secure. Fast. Reliable.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.blueGrayShade,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 40),

        _buildFeatureItem(Icons.person_outline, 'Patient Management'),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.description_outlined, 'Clinical Records'),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.calendar_today_outlined, 'Appointments'),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.bar_chart_outlined, 'Reports & Analytics'),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.brightBlue,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.blueGrayShade, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.darkStaleBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginFormCard(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign In Successful'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Card(
          elevation: 12,
          shadowColor: AppColors.brightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(40),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(height: 8),

                            Text(
                              'Please sign in to continue',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.blueGrayShade,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),

                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameContoller,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          prefixIcon: Icon(Icons.person_outline, size: 20),
                          filled: true,
                          fillColor: AppColors.backgroundGradientIceBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.darkStaleBlue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0062FF),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obsecurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obsecurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obsecurePassword = !_obsecurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColors.backgroundGradientIceBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.blueGrayShade,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF0062FF),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: AppColors.brightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (vallue) {
                                    setState(() {
                                      _rememberMe = vallue ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.brightBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onLoginPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.login,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 5),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          border: Border(
                            top: BorderSide(color: AppColors.lightGray2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.lightTeal,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Your data is secure and encrypted',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.gray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: const Color.fromARGB(255, 224, 224, 224),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Version 1.0.0   |   © 2025 Your Organization',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          Row(
            children: [
              const Icon(Icons.language, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              const Text(
                'English',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const Icon(
                Icons.arrow_drop_down,
                size: 18,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 20),
              const Text(' | ', style: TextStyle(color: Color(0xFFCBD5E1))),
              const SizedBox(width: 20),
              const Icon(
                Icons.help_outline,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              const Text(
                'Help',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.headset_mic_outlined,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              const Text(
                'Contact Support',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
