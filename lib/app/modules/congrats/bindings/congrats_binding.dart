import 'package:get/get.dart';

import '../controllers/congrats_controller.dart';

class CongratsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CongratsController>(
      () => CongratsController(),
    );
  }
}
