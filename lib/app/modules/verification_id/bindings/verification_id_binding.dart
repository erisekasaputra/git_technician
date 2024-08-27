import 'package:get/get.dart';

import '../controllers/verification_id_controller.dart';

class VerificationIdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationIdController>(
      () => VerificationIdController(),
    );
  }
}
