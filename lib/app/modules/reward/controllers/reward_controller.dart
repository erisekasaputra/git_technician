import 'package:get/get.dart';

class RewardController extends GetxController {
  final profileImageUrl = 'https://picsum.photos/200'.obs;
  final rating = 4.5.obs;
  final activeDate = '9 January 2023'.obs;
  final jobsCompleted = 5.obs;
  final totalJobs = 10.obs;
  final cancelations = 1.obs;
  final totalCancelations = 3.obs;
  final isActive = true.obs;

  final rewardDescription = 'Earn RM30.00 guarantee if technician met this week criteria'.obs;

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

  @override
  void onInit() {
    super.onInit();
    // You can fetch data from an API or local storage here
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
  }

  @override
  void onClose() {
    super.onClose();
    // Called when the controller is removed from memory
  }
}