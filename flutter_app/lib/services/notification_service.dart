import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:khalfan_center/models/notification_model.dart';
import 'package:khalfan_center/services/firebase_service.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Initialize notification channels and request permissions
  Future<void> init() async {
    // Request permission for iOS
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    
    // Initialize local notifications
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@drawable/ic_notification');
    
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped with response: ${response.payload}');
      },
    );
    
    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'khalfan_notifications', // id
      'Khalfan Center Notifications', // title
      description: 'Notifications from Khalfan Quran Memorization Center', // description
      importance: Importance.high,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    // Handle FCM messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }
  
  // Request notification permissions
  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  
  // Get FCM token for current device
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
  
  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
  
  // Save token to Firestore for a specific user
  Future<void> saveTokenToFirestore(String userId, FirebaseService firebaseService) async {
    String? token = await getToken();
    if (token != null) {
      await firebaseService.usersRef.doc(userId).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
      });
    }
  }
  
  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    // Show local notification
    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'khalfan_notifications',
            'Khalfan Center Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['payload'],
      );
    }
  }
  
  // Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'khalfan_notifications',
          'Khalfan Center Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
  
  // Save notification to Firestore
  Future<void> saveNotificationToFirestore({
    required FirebaseService firebaseService,
    required String userId,
    required String title,
    required String body,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    NotificationModel notification = NotificationModel(
      id: '',
      userId: userId,
      title: title,
      body: body,
      type: type ?? 'general',
      data: data,
      isRead: false,
      createdAt: DateTime.now(),
    );
    
    await firebaseService.notificationsRef.add(notification.toMap());
  }
}
