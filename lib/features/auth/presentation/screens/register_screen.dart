import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _nameCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passCtrl       = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool  _agreeToTerms   = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      context.showSnack('Please accept the terms to continue',
          isError: true);
      return;
    }
    final success = await ref.read(authProvider.notifier).register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!mounted) return;
    if (!success) {
      context.showSnack(
        ref.read(authProvider).errorMessage ?? 'Registration failed.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(
                  title:    'Create Account',
                  subtitle: 'Join us for delicious meals',
                ),
                const SizedBox(height: 36),

                AppTextField(
                  label:      'Full Name',
                  hint:       'John Doe',
                  controller: _nameCtrl,
                  prefixIcon: Icons.person_outline_rounded,
                  validator:  Validators.name,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label:        'Email',
                  hint:         'your@email.com',
                  controller:   _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon:   Icons.email_outlined,
                  validator:    Validators.email,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label:      'Password',
                  controller: _passCtrl,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator:  Validators.password,
                  helperText: 'Minimum 6 characters',
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label:           'Confirm Password',
                  controller:      _confirmCtrl,
                  isPassword:      true,
                  prefixIcon:      Icons.lock_outline_rounded,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passCtrl.text),
                  textInputAction: TextInputAction.done,
                  onSubmitted:     (_) => _register(),
                ),
                const SizedBox(height: 20),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24, height: 24,
                      child: Checkbox(
                        value:     _agreeToTerms,
                        onChanged: (v) =>
                            setState(() => _agreeToTerms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text:  'Terms of Service',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text:  'Privacy Policy',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                AppButton(
                  label:     'Create Account',
                  onPressed: _register,
                  isLoading: isLoading,
                  gradient:  AppColors.primaryGradient,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.labelLarge
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}