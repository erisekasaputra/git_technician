import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CongratulationController extends GetxController {
  final isLoading = false.obs;
  final isScanning = true.obs;
  final qrText = ''.obs;
  QRViewController? qrViewController;

  @override
  void onInit() {
    super.onInit();
  }

  void onQRViewCreated(QRViewController controller) {
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      qrText.value = scanData.code ?? '';
      isScanning.value = false;
      controller.pauseCamera();
    });
  }

  Future<void> onNextPressed() async {
    if (qrText.isNotEmpty) {
      isLoading.value = true;

      try {

        await Future.delayed(const Duration(seconds: 2));

        Get.offAllNamed(Routes.PRE_SERVICE_INSPECTION);

      } catch (e) {
        CustomToast.show(
          message: "Error",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      CustomToast.show(
        message: "Please scan a QR code first",
        type: ToastType.error,
      );

      Get.offAllNamed(Routes.PRE_SERVICE_INSPECTION);
    }
  }

  @override
  void onClose() {
    qrViewController?.dispose();
    super.onClose();
  }
}