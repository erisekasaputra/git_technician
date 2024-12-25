import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/domain/usecases/order/service_start.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';

class CongratulationController extends GetxController {
  final Logout logout = Logout();
  final HomeController? homeController =
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
  final isLoading = false.obs;
  final isScanning = true.obs;
  final qrText = ''.obs;
  QRViewController? qrViewController;
  final orderId = ''.obs;

  final ServiceStart serviceStart;

  CongratulationController({required this.serviceStart});

  @override
  void onInit() {
    super.onInit();
  }

  void onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      qrText.value = scanData.code ?? '';
      if (qrText.isNotEmpty) {
        isScanning.value = false;
        controller
            .pauseCamera(); // Pause camera only when QR is successfully scanned
      }
    });
  }

  Future<void> onNextPressed() async {
    if (homeController == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    if (isLoading.value) return; // Prevent multiple presses

    isLoading.value = true;
    try {
      if (qrText.isEmpty) {
        return;
      }

      var orderData = homeController!.orderData.value?.data;
      if (orderData == null) {
        return;
      }

      orderId.value = orderData.orderId;

      await serviceStart(
          orderData.orderId, orderData.fleets.first.fleetId, qrText.value);

      await homeController!.loadMechanicStatus();

      if (homeController!.orderData.value?.data != null &&
          homeController!.orderData.value?.data.orderStatus ==
              OrderStatus.serviceInProgress) {
        Get.toNamed(Routes.PRE_SERVICE_INSPECTION);
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          var messageError = parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: '${error.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      if (!isScanning.value) {
        qrViewController?.resumeCamera();
        isScanning.value = true;
      }
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    qrViewController?.dispose(); // Dispose the QR view controller
    super.onClose();
  }
}
