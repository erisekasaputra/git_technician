import 'package:get/get.dart';

import '../controllers/pre_service_inspection_controller.dart';

class PreServiceInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreServiceInspectionController>(
      () => PreServiceInspectionController(),
    );
  }
}
