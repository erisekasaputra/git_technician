import 'package:get/get.dart';

import '../controllers/support_screen_controller.dart';

class SupportScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupportScreenController>(
      SupportScreenController(),
    );
  }
}
