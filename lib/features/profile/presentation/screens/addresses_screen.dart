import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/profile_provider.dart';
import '../../../orders/providers/orders_provider.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(profileAddressesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final addr = addresses[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: addr.isDefault
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
              boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    addr.label == 'Home' ? Icons.home_rounded : Icons.business_rounded,
                    color: AppColors.primary, size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(addr.label, style: AppTextStyles.titleMedium),
                          if (addr.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Default',
                                  style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontSize: 10)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(addr.fullAddress,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                if (!addr.isDefault)
                  TextButton(
                    onPressed: () {
                      ref.read(profileAddressesProvider.notifier).setDefault(addr.id);
                      ref.read(selectedAddressProvider.notifier).state = addr;
                    },
                    child: const Text('Set Default'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}