import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/controllers/device_info_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/services/signal_r_service.dart';
import 'package:santai_technician/app/services/timezone_service.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class SplashScreenController extends GetxController {
  SignalRService? signalRService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;
  ChatSignalRService? chatSignalRService =
      Get.isRegistered<ChatSignalRService>()
          ? Get.find<ChatSignalRService>()
          : null;
  final Logout logout = Logout();
  DeviceInfoController? deviceInfoController =
      Get.isRegistered<DeviceInfoController>()
          ? Get.find<DeviceInfoController>()
          : null;
  final TimezoneService timezoneService = TimezoneService();
  final SessionManager sessionManager = SessionManager();
  final CommonGetImgUrlPublic commonGetImgUrlPublic;
  final GetUserProfile getUserProfile;

  SplashScreenController(
      {required this.commonGetImgUrlPublic, required this.getUserProfile});

  @override
  void onInit() async {
    super.onInit();
    initializeApp();
    await signalRService!.initializeConnection();
    await chatSignalRService!.initializeConnection();
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool connected = true;
    for (var connect in connectivityResult) {
      if (connect == ConnectivityResult.none) {
        connected = false;
      }
    }
    return connected;
  }

  Future<void> initializeApp() async {
    if (await _checkInternetConnection()) {
      try {
        final response = await commonGetImgUrlPublic();

        await sessionManager.setSessionBy(
            SessionManagerType.commonFileUrl, response.data.url);
        String accessToken =
            await sessionManager.getSessionBy(SessionManagerType.accessToken);
        String userId =
            await sessionManager.getSessionBy(SessionManagerType.userId);

        if (accessToken.isEmpty || userId.isEmpty) {
          Get.offAllNamed(Routes.LOGIN);
          return;
        }

        var userProfile = await getUserProfile(userId);
        if (userProfile == null) {
          Get.offAllNamed(Routes.USER_REGISTRATION);
          return;
        }

        await sessionManager.registerSessionForProfile(
          userName:
              '${userProfile.data?.personalInfo.firstName} ${userProfile.data?.personalInfo.middleName ?? ''} ${userProfile.data?.personalInfo.lastName ?? ''}',
          timeZone: userProfile.data?.timeZoneId ?? '',
          phoneNumber: userProfile.data?.timeZoneId ?? '',
          imageProfile: userProfile.data?.personalInfo.profilePicture ?? '',
          referralCode: userProfile.data?.referral?.referralCode ?? '',
        );

        Get.offAllNamed(Routes.HOME);
      } catch (error) {
        if (error is CustomHttpException) {
          if (error.statusCode == 401) {
            await logout.doLogout();
            return;
          }
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
        } else {
          CustomToast.show(
            message: "An unexpected error occurred ",
            type: ToastType.error,
          );
        }
      }
    } else {
      CustomToast.show(
        message: "No internet connection. Please check your network.",
        type: ToastType.error,
      );
    }
  }
}
