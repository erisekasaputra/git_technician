import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class BookingAcceptedController extends GetxController {
  final distance = 300.obs;
  final arrivalTime = '4:20 PM'.obs;
  final orderId = '9237363'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(Routes.CONGRATULATION);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}