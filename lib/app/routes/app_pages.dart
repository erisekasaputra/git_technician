import 'package:get/get.dart';

import '../modules/booking_accepted/bindings/booking_accepted_binding.dart';
import '../modules/booking_accepted/views/booking_accepted_view.dart';
import '../modules/congrats/bindings/congrats_binding.dart';
import '../modules/congrats/views/congrats_view.dart';
import '../modules/congratulation/bindings/congratulation_binding.dart';
import '../modules/congratulation/views/congratulation_view.dart';
import '../modules/congratulation_service/bindings/congratulation_service_binding.dart';
import '../modules/congratulation_service/views/congratulation_service_view.dart';
import '../modules/detail_inspection/bindings/detail_inspection_binding.dart';
import '../modules/detail_inspection/views/detail_inspection_view.dart';
import '../modules/financial/bindings/financial_binding.dart';
import '../modules/financial/views/financial_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/job_checklist/bindings/job_checklist_binding.dart';
import '../modules/job_checklist/views/job_checklist_view.dart';
import '../modules/job_history/bindings/job_history_binding.dart';
import '../modules/job_history/views/job_history_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pre-service_inspection/bindings/pre_service_inspection_binding.dart';
import '../modules/pre-service_inspection/views/pre_service_inspection_view.dart';
import '../modules/register_otp/bindings/register_otp_binding.dart';
import '../modules/register_otp/views/register_otp_view.dart';
import '../modules/reward/bindings/reward_binding.dart';
import '../modules/reward/views/reward_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/support_screen/bindings/support_screen_binding.dart';
import '../modules/support_screen/views/support_screen_view.dart';
import '../modules/user_registration/bindings/user_registration_binding.dart';
import '../modules/user_registration/views/user_registration_view.dart';
import '../modules/verification/bindings/verification_binding.dart';
import '../modules/verification/views/verification_view.dart';
import '../modules/verification_id/bindings/verification_id_binding.dart';
import '../modules/verification_id/views/verification_id_view.dart';
import '../modules/verification_license/bindings/verification_license_binding.dart';
import '../modules/verification_license/views/verification_license_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const durationTransision = const Duration(milliseconds: 200);

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.USER_REGISTRATION,
      page: () => const UserRegistrationView(),
      binding: UserRegistrationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => const VerificationView(),
      binding: VerificationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.VERIFICATION_ID,
      page: () => const VerificationIdView(),
      binding: VerificationIdBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.VERIFICATION_LICENSE,
      page: () => const VerificationLicenseView(),
      binding: VerificationLicenseBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.CONGRATS,
      page: () => const CongratsView(),
      binding: CongratsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision, 
    ),
    GetPage(
      name: _Paths.CONGRATULATION,
      page: () => const CongratulationView(),
      binding: CongratulationBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.PRE_SERVICE_INSPECTION,
      page: () => const PreServiceInspectionView(),
      binding: PreServiceInspectionBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.DETAIL_INSPECTION,
      page: () => const DetailInspectionView(),
      binding: DetailInspectionBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.CONGRATULATION_SERVICE,
      page: () => const CongratulationServiceView(),
      binding: CongratulationServiceBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.BOOKING_ACCEPTED,
      page: () => const BookingAcceptedView(),
      binding: BookingAcceptedBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.REWARD,
      page: () => const RewardView(),
      binding: RewardBinding(),
      transition: Transition.downToUp,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.JOB_HISTORY,
      page: () => const JobHistoryView(),
      binding: JobHistoryBinding(),
      transition: Transition.downToUp,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.downToUp,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.FINANCIAL,
      page: () => const FinancialView(),
      binding: FinancialBinding(),
      transition: Transition.downToUp,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.JOB_CHECKLIST,
      page: () => const JobChecklistView(),
      binding: JobChecklistBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.SUPPORT_SCREEN,
      page: () => const SupportScreenView(),
      binding: SupportScreenBinding(),
      transition: Transition.downToUp,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.REGISTER_OTP,
      page: () => const RegisterOtpView(),
      binding: RegisterOtpBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: durationTransision,
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
      transition: Transition.fadeIn,
      transitionDuration: durationTransision,
    ),
  ];
}
