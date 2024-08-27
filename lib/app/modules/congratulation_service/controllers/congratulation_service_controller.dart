import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class CongratulationServiceController extends GetxController {
  final isScanning = false.obs;
  final qrText = ''.obs;

  void scanQRCode() async {
    isScanning.value = true;
    // Implement QR code scanning logic here
    // For example, you can use the qr_code_scanner package
    // When QR code is scanned successfully:
    // 1. Set qrText.value to the scanned result
    // 2. Set isScanning.value to false
    // 3. Call returnToHomeScreen()
  }

  void returnToHomeScreen() {
    // Navigate to the home screen
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onInit() {
    super.onInit();
    // Start a timer to automatically return to home screen after a certain period
    Future.delayed(const Duration(seconds: 30), () {
      if (!isScanning.value) {
        // returnToHomeScreen();
      }
    });
  }
}