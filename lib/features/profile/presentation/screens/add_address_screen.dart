import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../domain/models/address_model.dart';
import '../../providers/profile_provider.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _labelCtrl  = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _cityCtrl   = TextEditingController();
  final _stateCtrl  = TextEditingController();
  final _zipCtrl    = TextEditingController();
  AddressType _type = AddressType.home;

  @override
  void dispose() {
    _labelCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final addr = AddressModel(
      id:     'addr_${DateTime.now().millisecondsSinceEpoch}',
      label:  _labelCtrl.text.trim(),
      type:   _type,
      street: _streetCtrl.text.trim(),
      city:   _cityCtrl.text.trim(),
      state:  _stateCtrl.text.trim(),
      zip:    _zipCtrl.text.trim(),
    );
    ref.read(profileAddressesProvider.notifier).add(addr);
    context.showSnack('Address saved', icon: Icons.check_circle_outline);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _TypePicker(
              selected: _type,
              onSelect: (t) => setState(() => _type = t),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label:      'Label',
              hint:       'e.g. Home',
              controller: _labelCtrl,
              prefixIcon: Icons.label_outline,
              validator:  (v) => Validators.required(v, 'Label'),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label:      'Street Address',
              controller: _streetCtrl,
              prefixIcon: Icons.home_outlined,
              validator:  (v) => Validators.required(v, 'Street'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label:     'City',
                    controller: _cityCtrl,
                    validator: (v) => Validators.required(v, 'City'),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: AppTextField(
                    label:      'State',
                    controller: _stateCtrl,
                    validator:  (v) => Validators.required(v, 'State'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              label:        'ZIP Code',
              controller:   _zipCtrl,
              keyboardType: TextInputType.number,
              prefixIcon:   Icons.local_post_office_outlined,
              validator:    (v) => Validators.required(v, 'ZIP'),
              textInputAction: TextInputAction.done,
              onSubmitted:  (_) => _save(),
            ),
            const SizedBox(height: 32),
            AppButton(
              label:     'Save Address',
              onPressed: _save,
              gradient:  AppColors.primaryGradient,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Type picker ───────────────────────────────────────────────────────────────

class _TypePicker extends StatelessWidget {
  final AddressType                selected;
  final void Function(AddressType) onSelect;

  const _TypePicker({required this.selected, required this.onSelect});

  static IconData _icon(AddressType t) {
    switch (t) {
      case AddressType.home:  return Icons.home_rounded;
      case AddressType.work:  return Icons.business_rounded;
      case AddressType.other: return Icons.location_on_rounded;
    }
  }

  static String _label(AddressType t) {
    switch (t) {
      case AddressType.home:  return 'Home';
      case AddressType.work:  return 'Work';
      case AddressType.other: return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AddressType.values.map((t) {
        final isSelected = t == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:   const EdgeInsets.symmetric(horizontal: 4),
              padding:  const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.08)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.divider,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _icon(t),
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textHint,
                    size: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _label(t),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}