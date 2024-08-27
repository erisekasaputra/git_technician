import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_date_picker.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_modern_dropdown.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/user_registration_controller.dart';

class UserRegistrationView extends GetView<UserRegistrationController> {
  const UserRegistrationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CustomProgressIndicator(
                  totalSteps: 5,
                  currentStep: 2,
                  activeColor: primary_300,
                  inactiveColor: Colors.grey[300]!,
                  height: 3,
                  spacing: 4,
                ),
                const SizedBox(height: 20),
                const CustomLabel(text: 'Reference Code'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Reference Code',
                  icon: Icons.code,
                  controller: controller.referenceCodeController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'First Name'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'First Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Middle Name'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Middle Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Last Name'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Last Name',
                  icon: Icons.person,
                  controller: TextEditingController(),
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Phone'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: '[+6] 018 222 0060',
                  icon: Icons.phone,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Email'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Email',
                  icon: Icons.email,
                  controller: TextEditingController(), 
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Date of Birth'),
                          const SizedBox(height: 5),
                          CustomDatePicker(
                            hintText: 'Date of Birth',
                            controller: controller.dateOfBirthController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(text: 'Gender'),
                          const SizedBox(height: 5),
                          Obx(() => ModernDropdown(
                            selectedItem: controller.selectedGender.value,
                            items: controller.genderOptions,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                controller.selectedGender.value = newValue;
                              }
                            },
                            prefixIcon: Icons.person,
                            hintText: 'Select Gender',
                            width: double.infinity,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Address'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Address',
                  icon: Icons.location_on,
                  controller: controller.addressController,
                ),
                const SizedBox(height: 10),
                const CustomLabel(text: 'Postal Code'),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Postal Code',
                  icon: Icons.pin_drop,
                  controller: controller.posCodeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Obx(() => CustomElevatedButton(
                  text: 'Next',
                  onPressed: controller.isLoading.value ? null : controller.register,
                  isLoading: controller.isLoading.value,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
