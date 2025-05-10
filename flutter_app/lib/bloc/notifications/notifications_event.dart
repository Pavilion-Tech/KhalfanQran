import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeNotificationsEvent extends NotificationsEvent {}

class LoadUserNotificationsEvent extends NotificationsEvent {
  final String userId;

  const LoadUserNotificationsEvent({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class MarkNotificationAsReadEvent extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsReadEvent({
    required this.notificationId,
  });

  @override
  List<Object> get props => [notificationId];
}

class SendNotificationEvent extends NotificationsEvent {
  final String userId;
  final String title;
  final String body;
  final String? type;
  final Map<String, dynamic>? data;

  const SendNotificationEvent({
    required this.userId,
    required this.title,
    required this.body,
    this.type,
    this.data,
  });

  @override
  List<Object?> get props => [userId, title, body, type, data];
}
