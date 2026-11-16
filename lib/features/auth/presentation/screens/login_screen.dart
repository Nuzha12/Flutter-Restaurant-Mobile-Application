import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: AppConstants.sampleEmail);
  final _passCtrl = TextEditingController(text: AppConstants.samplePassword);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!success && mounted) {
      context.showSnackBar(ref.read(authProvider).errorMessage ?? 'Login failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title: 'Welcome back!',
                  subtitle: 'Sign in to your account',
                ),
                const SizedBox(height: 36),
                AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passCtrl,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: Validators.password,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.forgotPassword),
                    child: Text('Forgot Password?',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(label: 'Sign In', onPressed: _login, isLoading: isLoading),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or continue with',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                          label: 'Google', iconPath: '🌐', onPressed: () {}),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SocialLoginButton(
                          label: 'Apple', iconPath: '🍎', onPressed: () {}),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => context.push(RouteNames.register),
                      child: Text('Sign Up',
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo: ${AppConstants.sampleEmail} / ${AppConstants.samplePassword}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}