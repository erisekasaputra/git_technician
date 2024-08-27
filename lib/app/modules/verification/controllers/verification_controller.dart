import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class VerificationController extends GetxController {
  final isLoading = false.obs;


  Future<void> onNextPressed() async {
    isLoading.value = true;
    try {

      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(Routes.VERIFICATION_ID);

      CustomToast.show(
        message: "Verification Success",
        type: ToastType.success,
      );

      } catch (e) {
        CustomToast.show(
          message: "Verification Failed",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
  }
}