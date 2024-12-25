import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class CongratulationServiceController extends GetxController {
  void returnToHomeScreen() {
    Get.offAllNamed(Routes.HOME);
  }

  final isSuccess = true.obs;

  @override
  void onInit() {
    var success = Get.arguments?['status'] ?? 'success';

    if (success == 'success') {
      isSuccess.value = true;
    } else {
      isSuccess.value = false;
    }

    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(Routes.HOME);
    });
  }
}
