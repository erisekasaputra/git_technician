import 'dart:async';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/notification_service.dart';

class RegisterOtpController extends GetxController {
  final otpSource = ''.obs;
  final otp = ['', '', '', ''].obs;
  final canResend = true.obs;
  final resendTimer = 60.obs;

  final isLoadingSms = false.obs;
  final isLoadingWhatsApp = false.obs;

  final NotificationService _notificationService = NotificationService();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
    otpSource.value = Get.arguments?['source'] ?? '';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void updateOtpDigit(int index, String value) {
    otp[index] = value;
    if (otp.every((digit) => digit.isNotEmpty)) {
      verifyOtp();
    }
  }

 void verifyOtp() {
  try {
    final fullOtp = otp.join();
    print('Entered OTP: $fullOtp');

    Future.delayed(const Duration(milliseconds: 500), () {
      print('Attempting to navigate...');
      if (otpSource.value == 'login') {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.USER_REGISTRATION);
      }
      print('Navigation command executed');
    });
  } catch (e) {
    CustomToast.show(
      message: "Failed to authenticate with server",
      type: ToastType.error,
    );
  }
}

  void sendOtpViaSms() async {
    isLoadingSms.value = true;
    try {
      canResend.value = false;
      startResendTimer();
    } catch (e) {
      CustomToast.show(
        message: "Failed to send OTP via SMS",
        type: ToastType.error,
      );
    } finally {
      isLoadingSms.value = false;
    }
  }

  void sendOtpViaWhatsApp() async {
    isLoadingWhatsApp.value = true;
    try {
      _notificationService.showNotification(
        id: 0,
        title: 'Santai',
        body: 'OTP has been sent',
      );

      canResend.value = false;
      startResendTimer();
    } catch (e) {
      CustomToast.show(
        message: "Failed to send OTP via WhatsApp",
        type: ToastType.error,
      );
    } finally {
      isLoadingWhatsApp.value = false;
    }
  }

  void startResendTimer() {
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }
}
