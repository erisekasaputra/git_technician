import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

Future<void> showNotification({
  required int id,
  required String title,
  required String body,
}) async {
  print("Attempting to show notification: $title - $body");
  try {
    await notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Your Channel Name',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
    print("Notification shown successfully");
  } catch (e) {
    print("Error showing notification: $e");
  }
}

Future<void> showOrderNotification({
  required int id,
  required String title,
  required String body,
}) async {
  print("Attempting to show order notification: $title - $body");
  try {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_channel',
      'Order Notifications',
      importance: Importance.max,
      playSound: true,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await notificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('accept', 'Accept', showsUserInterface: true),
            AndroidNotificationAction('reject', 'Reject', showsUserInterface: true),
          ],
        ),
      ),
      payload: 'order_request',
    );
    print("Order notification shown successfully");
  } catch (e) {
    print("Error showing order notification: $e");
  }
}

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Your Channel Name',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}


// class YourController extends GetxController {
//   final NotificationService _notificationService = NotificationService();

//   void showSimpleNotification() {
//     _notificationService.showNotification(
//       id: 0,
//       title: 'Simple Notification',
//       body: 'This is a simple notification',
//     );
//   }

//   void scheduleNotification() {
//     _notificationService.scheduleNotification(
//       id: 1,
//       title: 'Scheduled Notification',
//       body: 'This is a scheduled notification',
//       scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
//     );
//   }

//   void cancelNotification(int id) {
//     _notificationService.cancelNotification(id);
//   }

//   void cancelAllNotifications() {
//     _notificationService.cancelAllNotifications();
//   }
// }