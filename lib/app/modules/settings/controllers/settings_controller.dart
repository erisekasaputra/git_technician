import 'package:get/get.dart';

class SettingsController extends GetxController {
  final profileImageUrl = 'https://picsum.photos/200'.obs;
  final technicianName = 'Mohd Fadzle Bin Ismail'.obs;
  final walletBalance = 300.00.obs;

  @override
  void onInit() {
    super.onInit();

  }
}