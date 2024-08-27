import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/controllers/permission_controller.dart';
import 'package:santai_technician/app/controllers/theme_controller.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/services/location_service.dart';
import 'package:santai_technician/app/services/notification_service.dart';
import 'package:santai_technician/app/services/signal_r_service.dart';
import 'package:santai_technician/app/services/timezone_service.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/device_info_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final timezoneService = TimezoneService();
  await timezoneService.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.initNotification();

  String timezone = await timezoneService.getDeviceTimezone();
  await timezoneService.saveTimezone(timezone);
  print('Updated device timezone: $timezone');

  Get.put(LocationService());
  Get.put(TimezoneService());
  Get.put(PermissionController());
  Get.put(ThemeController());
  Get.put(SignalRService());
  Get.put(notificationService);

  final homeController = Get.put(HomeController());

  await notificationService.notificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (details.actionId == 'accept') {
        homeController.acceptOrder();
      } else if (details.actionId == 'reject') {
        homeController.rejectOrder();
      }
    },
  );

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: AppTheme.lightTheme,
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(DeviceInfoController());
      }),
    ),
  );
}
