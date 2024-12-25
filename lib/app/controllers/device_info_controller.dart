import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class DeviceInfoController extends GetxController {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final SessionManager sessionManager = SessionManager();
  final deviceId = RxString('');

  @override
  void onInit() {
    super.onInit();
    getDeviceId();
  }

  Future<void> getDeviceId() async {
    String? storedDeviceId =
        await sessionManager.getSessionBy(SessionManagerType.deviceId);

    if (storedDeviceId.isNotEmpty) {
      deviceId.value = storedDeviceId;
    } else {
      String newDeviceId = await _generateDeviceId();
      await sessionManager.setSessionBy(
          SessionManagerType.deviceId, newDeviceId);
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
