import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/mock_notification_datasource.dart';
import '../../../domain/models/notification_model.dart';

final _notifDs = Provider((_) => MockNotificationDataSource());

final notificationsProvider = StateNotifierProvider<NotifNotifier, AsyncValue<List<NotificationModel>>>(
        (ref) => NotifNotifier(ref.read(_notifDs)));

final unreadCountProvider = Provider<int>((ref) {
  final notifs = ref.watch(notificationsProvider);
  return notifs.valueOrNull?.where((n) => !n.isRead).length ?? 0;
});

class NotifNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final MockNotificationDataSource _ds;
  NotifNotifier(this._ds) : super(const AsyncValue.loading()) { load(); }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _ds.getAll());
  }

  Future<void> markRead(String id) async {
    await _ds.markRead(id);
    final cur = state.valueOrNull ?? [];
    state = AsyncValue.data(cur.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList());
  }

  Future<void> markAllRead() async {
    await _ds.markAllRead();
    final cur = state.valueOrNull ?? [];
    state = AsyncValue.data(cur.map((n) => n.copyWith(isRead: true)).toList());
  }
}