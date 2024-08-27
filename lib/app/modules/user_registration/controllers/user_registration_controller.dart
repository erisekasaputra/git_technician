import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class UserRegistrationController extends GetxController {
  final isLoading = false.obs;

  final referenceCodeController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final posCodeController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final genderOptions = ['Male', 'Female'];
  final selectedGender = 'Male'.obs;


  Future<void> register() async {
    isLoading.value = true;

    try {

      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(Routes.VERIFICATION);

      CustomToast.show(
        message: "Registration Success",
        type: ToastType.success,
      );

    } catch (e) {
      CustomToast.show(
        message: "Registration Failed",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
    
  }


  @override
  void onClose() {
    referenceCodeController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    addressController.dispose();
    posCodeController.dispose();
    super.onClose();
  }
}
