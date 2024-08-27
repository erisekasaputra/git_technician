import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class VerificationLicenseController extends GetxController {
  final isLoading = false.obs;
  final frontIdImage = Rx<File?>(null);
  final backIdImage = Rx<File?>(null);
  final canProceed = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(frontIdImage, (_) => _updateCanProceed());
    ever(backIdImage, (_) => _updateCanProceed());
  }

  void _updateCanProceed() {
    canProceed.value = frontIdImage.value != null && backIdImage.value != null;
  }

  Future<void> pickImage(ImageSource source, bool isFrontImage) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      if (isFrontImage) {
        frontIdImage.value = File(pickedFile.path);
      } else {
        backIdImage.value = File(pickedFile.path);
      }
    }
  }


  Future<void> onNextPressed() async {
    isLoading.value = true;
    try {

      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(Routes.CONGRATS);

      CustomToast.show(
        message: "Verification ID Success",
        type: ToastType.success,
      );

      } catch (e) {
        CustomToast.show(
          message: "Verification ID Failed",
          type: ToastType.error,
        );
      } finally {
        isLoading.value = false;
      }
  }
}
