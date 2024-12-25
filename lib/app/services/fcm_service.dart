import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class FCMService extends GetxService {
  final SessionManager sessionManager = SessionManager();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_important_santai_technician_channel',
    'Santai Technology',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  bool _isRequestingPermission = false;

  Future<FCMService> init() async {
    await _requestPermissions();
    // await _setupNotificationChannels();
    // await _setupNotificationHandlers();
    // await _initializeLocalNotifications();
    // await _setupForegroundNotificationPresentation();
    await _saveToken();
    return this;
  }

  Future<void> _requestPermissions() async {
    if (_isRequestingPermission) {
      return;
    }
    try {
      _isRequestingPermission = true;
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<void> _setupNotificationChannels() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupNotificationHandlers() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  Future<void> _setupForegroundNotificationPresentation() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _saveToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await sessionManager.setSessionBy(SessionManagerType.deviceId, token);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    final data = message.data;
    _showLocalNotification(data);
  }

  void _showLocalNotification(Map<String, dynamic> data) {
    if (data.isNotEmpty) {
      List<AndroidNotificationAction>? actions;
      try {
        if (data['actions'] is String) {
          actions = (json.decode(data['actions']) as List<dynamic>)
              .map((action) {
                final actionId = action['action'] as String?;
                final actionTitle = action['title'] as String?;
                if (actionId != null && actionTitle != null) {
                  return AndroidNotificationAction(
                    actionId,
                    actionTitle,
                    showsUserInterface: true,
                  );
                }
                return null;
              })
              .where((element) => element != null)
              .cast<AndroidNotificationAction>()
              .toList();
        }
      } catch (_) {}

      _flutterLocalNotificationsPlugin.show(
        0,
        data['title'] ?? 'Default title', // Provide a default title if null
        (data['body'] ?? 'Default body') +
            data.toString(), // Provide a default body if null
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            actions: actions,
          ),
        ),
        payload: data['orderId'],
      );
    }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      if (response.actionId != null) {
        switch (response.actionId) {
          case 'accept_action':
            break;
          case 'decline_action':
            break;
          default:
        }
      } else {
        // Navigate to order details screen
      }
    }
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_important_santai_technician_channel',
    'Santai Technology',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  List<AndroidNotificationAction>? actions;
  if (message.data.isNotEmpty) {
    try {
      if (message.data['actions'] is String) {
        actions = (json.decode(message.data['actions']) as List<dynamic>)
            .map((action) {
              final actionId = action['action'] as String?;
              final actionTitle = action['title'] as String?;
              if (actionId != null && actionTitle != null) {
                return AndroidNotificationAction(
                  actionId,
                  actionTitle,
                  showsUserInterface: true,
                );
              }
              return null;
            })
            .where((element) => element != null)
            .cast<AndroidNotificationAction>()
            .toList();
      }
    } catch (_) {}
  }

  await flutterLocalNotificationsPlugin.show(
    0,
    message.data['title'].toString(),
    message.data['body'].toString(),
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        actions: actions,
      ),
    ),
    payload: message.data['orderId'],
  );
}
