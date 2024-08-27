import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceInfoController extends GetxController {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final deviceId = RxString('');

  @override
  void onInit() {
    super.onInit();
    getDeviceId();
  }

  Future<void> getDeviceId() async {
    String? storedDeviceId = await secureStorage.read(key: 'device_id');

    if (storedDeviceId != null) {
      deviceId.value = storedDeviceId;
    } else {
      String newDeviceId = await _generateDeviceId();
      await secureStorage.write(key: 'device_id', value: newDeviceId);
      deviceId.value = newDeviceId;
    }
  }

  Future<String> _generateDeviceId() async {
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (GetPlatform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    } else {
      return 'unknown';
    }
  }
}