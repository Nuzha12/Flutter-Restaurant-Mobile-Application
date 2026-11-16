import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool  _sent      = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authProvider.notifier)
        .sendPasswordReset(_emailCtrl.text.trim());
    if (!mounted) return;
    if (success) {
      setState(() => _sent = true);
    } else {
      context.showSnack(
        ref.read(authProvider).errorMessage ?? 'Failed to send reset link.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _SuccessView(email: _emailCtrl.text) : _FormView(
          formKey:   _formKey,
          emailCtrl: _emailCtrl,
          isLoading: isLoading,
          onSend:    _send,
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String email;
  const _SuccessView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size:  80,
          color: AppColors.success,
        ),
        const SizedBox(height: 24),
        Text('Check Your Email', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 12),
        Text(
          "We've sent a reset link to $email",
          style:     AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppButton(
          label:     'Back to Sign In',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}

class _FormView extends StatelessWidget {
  final GlobalKey<FormState>    formKey;
  final TextEditingController   emailCtrl;
  final bool                    isLoading;
  final VoidCallback            onSend;

  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Forgot Password?', style: AppTextStyles.displayMedium),
          const SizedBox(height: 8),
          Text(
            "Enter your email and we'll send you a reset link.",
            style: AppTextStyles.bodyLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 36),
          AppTextField(
            label:           'Email',
            controller:      emailCtrl,
            keyboardType:    TextInputType.emailAddress,
            prefixIcon:      Icons.email_outlined,
            validator:       Validators.email,
            textInputAction: TextInputAction.done,
            onSubmitted:     (_) => onSend(),
          ),
          const SizedBox(height: 28),
          AppButton(
            label:     'Send Reset Link',
            onPressed: onSend,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}