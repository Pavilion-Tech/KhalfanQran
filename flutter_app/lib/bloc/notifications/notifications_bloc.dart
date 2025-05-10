import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khalfan_center/bloc/notifications/notifications_event.dart';
import 'package:khalfan_center/bloc/notifications/notifications_state.dart';
import 'package:khalfan_center/models/notification_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';
import 'package:khalfan_center/services/notification_service.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationService notificationService;
  final FirebaseService firebaseService;
  
  NotificationsBloc({
    required this.notificationService,
    required this.firebaseService,
  }) : super(NotificationsInitial()) {
    on<InitializeNotificationsEvent>(_onInitializeNotifications);
    on<LoadUserNotificationsEvent>(_onLoadUserNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<SendNotificationEvent>(_onSendNotification);
  }

  FutureOr<void> _onInitializeNotifications(InitializeNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    try {
      await notificationService.init();
      
      // If user is logged in, save FCM token to Firestore
      User? currentUser = firebaseService.currentUser;
      if (currentUser != null) {
        await notificationService.saveTokenToFirestore(currentUser.uid, firebaseService);
      }
      
      emit(NotificationsInitialized());
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadUserNotifications(LoadUserNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    try {
      List<NotificationModel> notifications = await firebaseService.getUserNotifications(event.userId);
      
      // Sort notifications by date (newest first)
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Count unread notifications
      int unreadCount = notifications.where((notification) => !notification.isRead).length;
      
      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  FutureOr<void> _onMarkNotificationAsRead(MarkNotificationAsReadEvent event, Emitter<NotificationsState> emit) async {
    try {
      await firebaseService.markNotificationAsRead(event.notificationId);
      
      // Reload notifications
      if (firebaseService.currentUser != null) {
        add(LoadUserNotificationsEvent(userId: firebaseService.currentUser!.uid));
      }
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  FutureOr<void> _onSendNotification(SendNotificationEvent event, Emitter<NotificationsState> emit) async {
    try {
      // Save notification to Firestore
      await notificationService.saveNotificationToFirestore(
        firebaseService: firebaseService,
        userId: event.userId,
        title: event.title,
        body: event.body,
        type: event.type,
        data: event.data,
      );
      
      // Show local notification if the target user is the current user
      if (firebaseService.currentUser != null && firebaseService.currentUser!.uid == event.userId) {
        await notificationService.showLocalNotification(
          title: event.title,
          body: event.body,
          payload: event.data != null ? event.data.toString() : null,
        );
      }
      
      // Reload notifications if the target user is the current user
      if (firebaseService.currentUser != null && firebaseService.currentUser!.uid == event.userId) {
        add(LoadUserNotificationsEvent(userId: firebaseService.currentUser!.uid));
      }
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }
}
