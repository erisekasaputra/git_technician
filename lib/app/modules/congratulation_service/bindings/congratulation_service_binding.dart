import 'package:get/get.dart';

import '../controllers/congratulation_service_controller.dart';

class CongratulationServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CongratulationServiceController>(
      CongratulationServiceController(),
    );
  }
}
