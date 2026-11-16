import 'package:equatable/equatable.dart';

enum NotificationType { order, promo, system, loyalty }

class NotificationModel extends Equatable {
  final String           id;
  final String           title;
  final String           body;
  final NotificationType type;
  final DateTime         createdAt;
  final bool             isRead;
  final String?          actionRoute;

  const NotificationModel({
    required this.id, required this.title, required this.body,
    required this.type, required this.createdAt,
    this.isRead = false, this.actionRoute,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id, title: title, body: body, type: type,
    createdAt: createdAt, actionRoute: actionRoute,
    isRead: isRead ?? this.isRead,
  );

  @override
  List<Object> get props => [id, isRead];
}