import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:whats_clone/core/routes/app_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/routes/route_params.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';
import 'package:whats_clone/state/notification/services/fcm_token_repository.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifications();
//   await NotificationService.instance.showNotification(message);
// }

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FcmTokenRepository _fcmTokenRepository;
  final String userId;

  @pragma('vm:entry-point')
  NotificationService({
    required this.userId,
    required FcmTokenRepository fcmTokenRepository,
  }) : _fcmTokenRepository = fcmTokenRepository;

  /// Initialize Notification Service
  @pragma('vm:entry-point')
  Future<void> initialize() async {
    await _requestPermission();
    await _setupTokenManagement();
    await _initializeLocalNotifications();
    _setupMessageListeners();
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // log.i('User granted notification permissions');
    } else {
      log.w('User denied notification permissions');
    }
  }

  /// Token management: Save and handle FCM token
  Future<void> _setupTokenManagement() async {
    // Get current token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      // log.i('FCM Token retrieved: $token');
      await _fcmTokenRepository
          .setToken(FcmToken(token: token, userId: userId));
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log.i('FCM Token refreshed: $newToken');
      await _fcmTokenRepository
          .setToken(FcmToken(token: newToken, userId: userId));
    });
  }

  /// Initialize Flutter Local Notifications for foreground messages
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (response.payload != null) {
          final data = json.decode(response.payload!) as Map<String, dynamic>;
          _handleMessageNavigation(data);
        }
      },
    );

    log.i('Local notifications initialized');
  }

  /// Handle incoming messages
  void _setupMessageListeners() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.i('Message received in foreground: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.i('Message opened from background: ${message.notification?.title}');
      _handleBackgroundMessage(message);
    });

    // Terminated messages
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log.i(
            'Message received in terminated state: ${message.notification?.title}');
        _handleTerminatedMessage(message);
      }
    });
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This is the default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  /// Handle background message
  void _handleBackgroundMessage(RemoteMessage message) {
    log.i('Handling background message: ${message.data}');
    _handleMessageNavigation(message.data);
  }

  /// Handle terminated state message
  void _handleTerminatedMessage(RemoteMessage message) {
    log.i('Handling terminated state message: ${message.data}');
    _handleMessageNavigation(message.data);
  }

  /// Handle navigation based on message data
  void _handleMessageNavigation(Map<String, dynamic> data) {
    if (data['type'] == 'message' && data['chatId'] != null) {
      final chatId = data['chatId'] as String;
      appRouter.pushNamed(
        RouteName.chatRoom,
        pathParameters: {
          RouteParams.chatId: chatId,
        },
      );
      // Get the chat profile and navigate
      // final navigatorState = navigatorKey.currentState;
      // if (navigatorState != null) {
      //   navigatorState.pushNamed(
      //     '/${RouteName.chats}/${RouteName.chatRoom}/$chatId',
      //   );
      // }
    }
  }
}
