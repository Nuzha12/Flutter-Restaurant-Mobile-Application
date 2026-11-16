import '../../domain/models/notification_model.dart';

class MockNotificationDataSource {
  final List<NotificationModel> _items = [
    NotificationModel(id: 'n1', title: 'Order Confirmed!', body: 'Your order #ORD8821 has been confirmed and is being prepared.', type: NotificationType.order, createdAt: DateTime.now().subtract(const Duration(minutes: 5)), actionRoute: '/orders'),
    NotificationModel(id: 'n2', title: '30% Off Today Only!', body: 'Use code SAVE30 on your next order. Valid until midnight.', type: NotificationType.promo, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationModel(id: 'n3', title: 'You earned 150 points!', body: 'Keep ordering to unlock Gold status and exclusive rewards.', type: NotificationType.loyalty, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationModel(id: 'n4', title: 'Order Delivered', body: 'Your order #ORD7743 has been delivered. Enjoy your meal!', type: NotificationType.order, createdAt: DateTime.now().subtract(const Duration(days: 1)), isRead: true),
    NotificationModel(id: 'n5', title: 'New on the menu', body: 'Try our new Crispy Chicken Burger — now available for a limited time.', type: NotificationType.system, createdAt: DateTime.now().subtract(const Duration(days: 2)), isRead: true),
  ];

  Future<List<NotificationModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_items);
  }

  Future<void> markRead(String id) async {
    final i = _items.indexWhere((n) => n.id == id);
    if (i >= 0) _items[i] = _items[i].copyWith(isRead: true);
  }

  Future<void> markAllRead() async {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
  }

  int get unreadCount => _items.where((n) => !n.isRead).length;
}