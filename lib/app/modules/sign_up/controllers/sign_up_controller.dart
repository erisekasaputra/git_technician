import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
   final isAgreed = false.obs;

  final TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  final phoneController = TextEditingController();
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);


  void updatePhoneInfo(String code, String number) {
  countryCode.value = code;
  phoneNumber.value = number;
}
Future<void> signUp() async {
    isLoading.value = true;

    String password = passwordController.text;
    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';
  
    try {
      await Future.delayed(const Duration(seconds: 2));

      CustomToast.show(
        message: "Successfully registered!",
        type: ToastType.success,
      );

      print('Phone: $fullPhoneNumber, Password: $password');
      Get.offAllNamed(Routes.REGISTER_OTP);

    } catch (error) {
      CustomToast.show(
        message: "Something went wrong.",
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

      CustomToast.show(
        message: 'idToken: $idToken Access Token: $accessToken',
        type: ToastType.success,
      );

      bool success = await sendTokenToServer(idToken);
      
      if (success) {
  
        Get.toNamed(Routes.REGISTER_OTP, arguments: {'source': 'signup'});
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
  
    return true;
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

}
