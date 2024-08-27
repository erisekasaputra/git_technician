import 'package:get/get.dart';

import '../controllers/detail_inspection_controller.dart';

class DetailInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailInspectionController>(
      () => DetailInspectionController(),
    );
  }
}
