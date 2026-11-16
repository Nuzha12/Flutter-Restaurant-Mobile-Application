import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/models/notification_model.dart';
import '../../../notifications/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
            child: Text('Mark all read', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => items.isEmpty
            ? const EmptyStateWidget(icon: Icons.notifications_none_rounded, title: 'No notifications', subtitle: 'You\'re all caught up!')
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _NotifTile(notif: items[i])
              .animate().fadeIn(delay: (i * 50).ms).slideX(begin: -0.05),
        ),
      ),
    );
  }
}

class _NotifTile extends ConsumerWidget {
  final NotificationModel notif;
  const _NotifTile({required this.notif});

  IconData get _icon {
    switch (notif.type) {
      case NotificationType.order:   return Icons.shopping_bag_outlined;
      case NotificationType.promo:   return Icons.local_offer_outlined;
      case NotificationType.loyalty: return Icons.star_outline_rounded;
      case NotificationType.system:  return Icons.info_outline_rounded;
    }
  }

  Color get _color {
    switch (notif.type) {
      case NotificationType.order:   return AppColors.info;
      case NotificationType.promo:   return AppColors.error;
      case NotificationType.loyalty: return AppColors.gold;
      case NotificationType.system:  return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(notificationsProvider.notifier).markRead(notif.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: notif.isRead ? AppColors.divider : AppColors.primary.withOpacity(0.15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(_icon, color: _color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(notif.title, style: AppTextStyles.titleMedium)),
                      if (!notif.isRead)
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(Formatters.relativeTime(notif.createdAt), style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}