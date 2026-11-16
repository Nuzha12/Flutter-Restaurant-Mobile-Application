import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _emailUpdates = false;
  bool _locationServices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _Header('Notifications'),
          SwitchListTile(
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            title: const Text('Push Notifications'),
            subtitle: const Text('Order updates and promotions'),
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            value: _emailUpdates,
            onChanged: (v) => setState(() => _emailUpdates = v),
            title: const Text('Email Updates'),
            subtitle: const Text('Weekly deals and newsletters'),
            activeThumbColor: AppColors.primary,
          ),
          const _Header('Privacy'),
          SwitchListTile(
            value: _locationServices,
            onChanged: (v) => setState(() => _locationServices = v),
            title: const Text('Location Services'),
            subtitle: const Text('For accurate delivery estimates'),
            activeThumbColor: AppColors.primary,
          ),
          const _Header('About'),
          ListTile(title: const Text('Version'), trailing: Text('1.0.0', style: AppTextStyles.bodySmall)),
          ListTile(title: const Text('Privacy Policy'), trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint), onTap: () {}),
          ListTile(title: const Text('Terms of Service'), trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint), onTap: () {}),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String label;
  const _Header(this.label);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(label, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textHint, letterSpacing: 1)),
  );
}