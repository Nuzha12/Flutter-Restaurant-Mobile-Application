import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user!;
    _nameCtrl = TextEditingController(text: user.name);
    _phoneCtrl = TextEditingController(text: user.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final user = ref.read(authProvider).user!;
    await ref.read(authProvider.notifier).updateProfile(
      user.copyWith(name: _nameCtrl.text.trim(), phone: _phoneCtrl.text.trim()),
    );
    if (mounted) {
      setState(() => _saving = false);
      context.showSnackBar('Profile updated successfully');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Full Name',
                controller: _nameCtrl,
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone Number',
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              AppButton(label: 'Save Changes', onPressed: _save, isLoading: _saving),
            ],
          ),
        ),
      ),
    );
  }
}