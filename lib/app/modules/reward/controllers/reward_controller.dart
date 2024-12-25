import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/custom_date_extension.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class RewardController extends GetxController {
  final SessionManager sessionManager = SessionManager();
  final GetUserProfile getUserProfile;
  final Logout logout = Logout();
  final isLoading = false.obs;
  final profileImageUrl = ''.obs;
  final commonUrl = ''.obs;
  final rating = 5.0.obs;
  final activeDate = ''.obs;

  final totalCancelledJob = 0.obs;
  final totalCompletedJob = 0.obs;
  final totalEntireJob = 0.obs;
  final totalEntireJobBothCompleteIncomplete = 0.obs;

  final isActive = true.obs;

  final rewardDescription =
      'Earn RM30.00 guarantee if technician met this week criteria'.obs;

  final requirements = [
    'At least 1800 points',
    'Above 90% acceptance rate',
    'Below 10% cancelation rate',
    'Above 4.7 driver rating'
  ].obs;

  final conditions = [
    'Partners who did not meet the requirements will not eligible. this applies to all partners, regardless of whether they are an existing diamond partner or if they have just gone on a long holiday',
    'No appeals are allowed for this award',
    'These bonus points will be excluded from all multipliers from any other initiatives/'
  ].obs;

  RewardController({required this.getUserProfile});

  @override
  void onInit() async {
    super.onInit();
    await loadUserProfile();
    commonUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    profileImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.imageProfile);
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      var timezone =
          await sessionManager.getSessionBy(SessionManagerType.timeZone);
      var userId = await sessionManager.getSessionBy(SessionManagerType.userId);
      if (userId.isEmpty || timezone.isEmpty) {
        return;
      }
      var userProfile = await getUserProfile(userId);
      if (userProfile == null || userProfile.data == null) {
        return;
      }

      rating.value = userProfile.data!.rating;
      totalCancelledJob.value = userProfile.data!.totalCancelledJob;
      totalCompletedJob.value = userProfile.data!.totalCompletedJob;
      totalEntireJob.value = userProfile.data!.totalEntireJob;
      totalEntireJobBothCompleteIncomplete.value =
          userProfile.data!.totalEntireJobBothCompleteIncomplete;
      activeDate.value = DateFormat('dd MMM yyyy')
          .format(userProfile.data!.createdAt.utcToLocal(timezone));
    } catch (e) {
      if (e is CustomHttpException) {
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      }
      CustomToast.show(
        message: "Uh-oh, there is an issue.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  double safeDivision(double value, double total) {
    if (total == 0) {
      return 0;
    }
    return value / total;
  }
}
