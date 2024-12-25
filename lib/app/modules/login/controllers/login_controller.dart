import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/register_otp/controllers/register_otp_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai_technician/app/domain/usecases/authentikasi/signin_user.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';

class LoginController extends GetxController {
  final registerOtpController = Get.isRegistered<RegisterOtpController>()
      ? Get.find<RegisterOtpController>()
      : null;
  final Logout logout = Logout();
  final isLoading = false.obs;

  TextEditingController passwordController = TextEditingController();
  final isPasswordHidden = true.obs;

  TextEditingController phoneController = TextEditingController();
  final countryISOCode = ''.obs;
  final countryCode = ''.obs;
  final phoneNumber = ''.obs;

  TextEditingController businessCodeController = TextEditingController();

  final UserSignIn signinUser;

  LoginController({required this.signinUser});

  final errorValidation = Rx<ErrorResponse?>(null);

  void updatePhoneInfo(String isoCode, String code, String number) {
    countryISOCode.value = isoCode;
    countryCode.value = code;
    phoneNumber.value = number;
  }

  void login() async {
    isLoading.value = true;

    String fullPhoneNumber = '${countryCode.value}${phoneNumber.value}';

    try {
      final dataUserSignIn = SigninUser(
        phoneNumber: fullPhoneNumber,
        password: passwordController.text,
        regionCode: countryISOCode.value,
      );

      final response = await signinUser(dataUserSignIn);

      if (response == null) {
        CustomToast.show(
            message:
                'We can not find your account in our database. Please make sure your credentials are correct',
            type: ToastType.error);
        return;
      }

      if (registerOtpController != null) {
        registerOtpController!.otpSource.value = 'login';
        registerOtpController!.otpRequestToken.value =
            response.next.otpRequestToken;
        registerOtpController!.otpRequestId.value = response.next.otpRequestId;
      }

      Get.toNamed(Routes.REGISTER_OTP, arguments: {
        'source': 'login',
        'otpRequestToken': response.next.otpRequestToken,
        'otpRequestId': response.next.otpRequestId,
      });
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }
        if (error.statusCode == 401) {
          errorValidation.value = null;
          await logout.doLogout();
          return;
        }
        errorValidation.value = null;
        CustomToast.show(
          message: error.message,
          type: ToastType.error,
        );
      } else {
        errorValidation.value = null;
        CustomToast.show(
          message: "Upps, Unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
