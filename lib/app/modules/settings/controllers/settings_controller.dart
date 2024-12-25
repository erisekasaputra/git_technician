import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/authentikasi/signout_user.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/utils/logout_helper.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class SettingsController extends GetxController {
  final isLoggingOut = false.obs;
  final walletBalance = 300.00.obs;
  final SessionManager sessionManager = SessionManager();

  final commonUrl = ''.obs;
  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final deviceId = ''.obs;
  final userId = ''.obs;
  final profileImageUrl = ''.obs;
  final userName = ''.obs;
  final phoneNumber = ''.obs;
  final currentLanguage = 'English (UK)';
  final SignOutUser signOutUser;

  SettingsController({required this.signOutUser});

  @override
  void onInit() async {
    super.onInit();

    accessToken.value =
        await sessionManager.getSessionBy(SessionManagerType.accessToken);
    commonUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    refreshToken.value =
        await sessionManager.getSessionBy(SessionManagerType.refreshToken);
    deviceId.value =
        await sessionManager.getSessionBy(SessionManagerType.deviceId);
    userId.value = await sessionManager.getSessionBy(SessionManagerType.userId);
    userName.value =
        await sessionManager.getSessionBy(SessionManagerType.userName);
    profileImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.imageProfile);
    phoneNumber.value =
        await sessionManager.getSessionBy(SessionManagerType.phoneNumber);
  }

  Future logout() async {
    isLoggingOut.value = true;
    try {
      await signOutUser(
        accessToken.value,
        refreshToken.value,
        deviceId.value,
      );
      await logoutSecureStorage();
      CustomToast.show(
        message: "Successfully logout!",
        type: ToastType.success,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      CustomToast.show(
        message: "Login failed: ${error.toString()}",
        type: ToastType.error,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }
}
