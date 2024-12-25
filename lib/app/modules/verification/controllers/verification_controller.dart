import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class VerificationController extends GetxController {
  final isLoading = false.obs;

  Future<void> onNextPressed() async {
    Get.toNamed(Routes.VERIFICATION_ID);
  }
}
