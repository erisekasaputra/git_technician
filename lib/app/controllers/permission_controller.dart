import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  final RxBool locationPermissionGranted = false.obs;

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    locationPermissionGranted.value = status.isGranted;
  }

  Future<void> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    locationPermissionGranted.value = status.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

}