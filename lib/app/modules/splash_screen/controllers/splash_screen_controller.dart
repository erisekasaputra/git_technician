import 'package:get/get.dart';
import 'package:santai_technician/app/controllers/permission_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/controllers/device_info_controller.dart';
import 'package:santai_technician/app/services/timezone_service.dart';

class SplashScreenController extends GetxController {
  final DeviceInfoController deviceInfoController = Get.find<DeviceInfoController>();
  final TimezoneService _timezoneService = Get.find<TimezoneService>();
  final PermissionController _permissionController = Get.find<PermissionController>();

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    await deviceInfoController.getDeviceId();
    await _permissionController.requestLocationPermission();
    
    Get.snackbar('Device ID', deviceInfoController.deviceId.value);

    String? userTimezone = await _timezoneService.getSavedTimezone();
    Get.snackbar('User Timezone', userTimezone ?? 'Timezone not set');
    
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(Routes.LOGIN);
  }
}