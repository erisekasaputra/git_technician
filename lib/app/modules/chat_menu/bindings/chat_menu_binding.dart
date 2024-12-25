import 'package:get/get.dart';

import '../controllers/chat_menu_controller.dart';

class ChatMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatMenuController>(
      () => ChatMenuController(),
    );
  }
}
