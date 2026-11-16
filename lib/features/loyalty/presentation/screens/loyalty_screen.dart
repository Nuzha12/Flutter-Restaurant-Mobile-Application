import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/providers/auth_provider.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final pts  = user?.loyaltyPoints ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Rewards')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _PointsCard(points: pts).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text('Rewards', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 14),
          ..._rewards(pts).map((r) => _RewardTile(reward: r).animate().fadeIn().slideX(begin: -0.05)),
          const SizedBox(height: 24),
          Text('How it works', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 14),
          _HowItWorks(),
        ],
      ),
    );
  }

  List<_Reward> _rewards(int pts) => [
    _Reward('Free Delivery',     '🚚', 200,  pts >= 200),
    _Reward('10% Off Order',     '🏷️', 500,  pts >= 500),
    _Reward('Free Dessert',      '🍰', 800,  pts >= 800),
    _Reward('VIP Chef\'s Table', '👨‍🍳', 2000, pts >= 2000),
  ];
}

class _Reward {
  final String name, emoji;
  final int    requiredPts;
  final bool   unlocked;
  _Reward(this.name, this.emoji, this.requiredPts, this.unlocked);
}

class _PointsCard extends StatelessWidget {
  final int points;
  const _PointsCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('$points', style: AppTextStyles.displayLarge.copyWith(color: Colors.white, fontSize: 48)),
          Text('Loyalty Points', style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(points < 500 ? '${500 - points} pts to Silver' : 'Gold Member 🏅',
                style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final _Reward reward;
  const _RewardTile({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reward.unlocked ? AppColors.gold.withOpacity(0.06) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: reward.unlocked ? AppColors.gold.withOpacity(0.3) : AppColors.divider),
        boxShadow: AppColors.cardShadows,
      ),
      child: Row(
        children: [
          Text(reward.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.name, style: AppTextStyles.titleMedium),
                Text('${reward.requiredPts} points required', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          reward.unlocked
              ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(20)),
              child: Text('Redeem', style: AppTextStyles.badge))
              : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
              child: Text('Locked', style: AppTextStyles.badge.copyWith(color: AppColors.textHint))),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const steps = [
      ('🛍️', 'Order food', 'Earn points on every order you place'),
      ('⭐', 'Collect points', '10 pts per \$1 spent on all items'),
      ('🎁', 'Redeem rewards', 'Unlock free items, discounts & more'),
    ];
    return Column(
      children: steps.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Text(s.$1, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.$2, style: AppTextStyles.titleMedium),
                Text(s.$3, style: AppTextStyles.bodySmall),
              ],
            )),
          ],
        ),
      )).toList(),
    );
  }
}