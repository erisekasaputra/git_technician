import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

class JobChecklistController extends GetxController {
  final isLoading = false.obs;
  
  final orderId = '461522';
  final checklistItems = <ChecklistItem>[].obs;
  final vehicleUpdateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checklistItems.addAll([
      ChecklistItem('Front Brake'),
      ChecklistItem('Front Sprocket'),
      ChecklistItem('Chain'),
      ChecklistItem('Rear Sprocket'),
      ChecklistItem('Rear Brake'),
      ChecklistItem('Oil Change'),
      ChecklistItem('Oil Filter'),
      ChecklistItem('Spark Plug'),
    ]);
  }

  void onNextPressed() {
    // Implement the logic for the next button press
    print('Next button pressed');
    print('Checked items: ${checklistItems.where((item) => item.isChecked.value).map((item) => item.title).toList()}');
    print('Vehicle update: ${vehicleUpdateController.text}');
    Get.toNamed(Routes.CONGRATULATION_SERVICE);
  }

  @override
  void onClose() {
    vehicleUpdateController.dispose();
    super.onClose();
  }
}

class ChecklistItem {
  final String title;
  final RxBool isChecked;

  ChecklistItem(this.title) : isChecked = false.obs;
}