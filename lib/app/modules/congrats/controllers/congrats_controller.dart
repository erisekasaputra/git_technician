import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class CongratsController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _autoRedirect();
  }

  void _autoRedirect() {
    Future.delayed(const Duration(seconds: 5), () {
      isLoading.value = true;
      Get.offAllNamed(Routes.HOME);
    });
  }

  Future<void> onNextPressed() async {
    isLoading.value = true;
    try {

      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.HOME);

      } catch (e) {
        CustomToast.show(
          message: "Error",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
  }
}