import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai_technician/app/domain/usecases/login_use_case.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/modules/register_otp/views/register_otp_view.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;

  final LoginUseCase loginUseCase;
  final passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final businessCodeController = TextEditingController();
  final isStaffLogin = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  LoginController(this.loginUseCase);

   void updatePhoneInfo(String code, String number) {
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void login() async {
    isLoading.value = true;
    final password = passwordController.text;
    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {

      print('Phone: $fullPhoneNumber, Password: $password');
      await Future.delayed(Duration(seconds: 2));

      CustomToast.show(
          message: "Login successful",
          type: ToastType.success,
        );

      isLoading.value = false;
      Get.toNamed(Routes.REGISTER_OTP, arguments: {'source': 'login'});

      // final user = await loginUseCase.execute(phone, password);
      // print('Logged in user: ${user.email}');
      
    } catch (e) {
      CustomToast.show(
          message: "Login failed",
          type: ToastType.error,
        );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleStaffLogin() {
    isStaffLogin.toggle();
  }

  void signInAsStaff() async {
    isLoading.value = true;

    final phone = '${countryCode.value}${phoneNumber.value}';
    final password = passwordController.text;
    final businessCode = businessCodeController.text;

    if (phone.isEmpty || password.isEmpty || businessCode.isEmpty) {
      // ModernSnackbar.show(
      //   message: "Please fill in all fields",
      //   type: SnackbarType.warning,
      // );
      CustomToast.show(
          message: "Please fill in all fields",
          type: ToastType.warning,
        );
      isLoading.value = false;
      return;
    }

    try {

      await Future.delayed(Duration(seconds: 2));

      print('Staff Login - Phone: $phone, Password: $password, Business Code: $businessCode');
      
      isLoading.value = false;
      Get.toNamed(Routes.REGISTER_OTP);

      Get.to(
        () => const RegisterOtpView(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 500),
      );
      
    } catch (e) {
      CustomToast.show(
          message: "Login failed",
          type: ToastType.error,
        );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {


    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print('idToken: $idToken');
      print('accessToken: $accessToken');

      Get.snackbar('Success', 'idToken: $idToken Access Token: $accessToken');

      bool success = await sendTokenToServer(idToken);
      
      if (success) {
  
        Get.offAllNamed(Routes.REGISTER_OTP);
      } else {
    
        CustomToast.show(
          message: "Failed to authenticate with server",
          type: ToastType.error,
        );
      }
    } catch (error) {
      print(error);
      CustomToast.show(
          message: "Sign in with Google failed",
          type: ToastType.error,
        );
    }
  }

  Future<bool> sendTokenToServer(String? token) async {
  
    return true; // Placeholder
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
