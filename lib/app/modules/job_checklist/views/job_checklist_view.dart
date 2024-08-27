import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/job_checklist_controller.dart';

class JobChecklistView extends GetView<JobChecklistController> {
  const JobChecklistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
          child: CustomBackButton(
            onPressed: () => Get.back(),
          ),
        ),
        leadingWidth: 60,
        title: const Text(
          'Job Checklist',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Service Checklist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'OrderID #${controller.orderId}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...controller.checklistItems.map((item) => _buildChecklistItem(item, context)),
              const SizedBox(height: 24),
              const Text(
                'Vehicle Update',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.vehicleUpdateController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Placeholder',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderInput_01, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary_300, width: 2),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${controller.vehicleUpdateController.text.length}/200',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => CustomElevatedButton(
                  text: 'Next',
                  onPressed: controller.isLoading.value ? null : controller.onNextPressed,
                  isLoading: controller.isLoading.value,
                )),
    
            ],
          ),
        ),
      ),
    );
  }

Widget _buildChecklistItem(ChecklistItem item, BuildContext context) {
  final Color primary_300 = Theme.of(context).colorScheme.primary_300;
  final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;
  return Obx(() => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      border: Border.all(
        color: item.isChecked.value ? primary_300 : borderInput_01,
        width: item.isChecked.value ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: CheckboxListTile(
      title: Text(item.title),
      value: item.isChecked.value,
      onChanged: (bool? value) {
        item.isChecked.value = value ?? false;
      },
      activeColor: primary_300,
      checkColor: Colors.white,
      side: BorderSide(color: borderInput_01, width: 1),
    ),
  ));
}
}