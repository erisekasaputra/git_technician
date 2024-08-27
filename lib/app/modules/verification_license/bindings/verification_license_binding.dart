import 'package:get/get.dart';

import '../controllers/verification_license_controller.dart';

class VerificationLicenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationLicenseController>(
      () => VerificationLicenseController(),
    );
  }
}
