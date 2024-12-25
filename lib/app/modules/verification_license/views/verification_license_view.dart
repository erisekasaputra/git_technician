import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_image_uploader.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:santai_technician/app/utils/nullable_response_builder.dart';

import '../controllers/verification_license_controller.dart';

class VerificationLicenseView extends GetView<VerificationLicenseController> {
  const VerificationLicenseView({super.key});
  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                CustomProgressIndicator(
                  totalSteps: 5,
                  currentStep: 5,
                  activeColor: primary_300,
                  inactiveColor: Colors.grey[300]!,
                  height: 3,
                  spacing: 4,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Licenses\nVerification',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We need a photo of your License ID',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  'To complete your registration u must upload a photo of your license ID card front and back.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Capture Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please positions your doucment so that it fills the frame of your screen',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                _buildInstructionItem(
                    Icons.crop_free, 'Place it onf a flat surface'),
                const SizedBox(height: 5),
                _buildInstructionItem(
                    Icons.blur_off, 'Avoid glare, shaking, and blur'),
                const SizedBox(height: 20),
                Obx(() => CustomImageUploader(
                      selectedImage: controller
                          .userRegController?.drivingLicenseFrontIdImage.value,
                      onImageSourceSelected: (source) =>
                          controller.pickImage(source, true),
                      height: 150,
                      fieldName: "DrivingLicense.FrontSideImageUrl",
                      error: controller.userRegController?.errorValidation ??
                          getNonNullResponse(),
                    )),
                const SizedBox(height: 20),
                Obx(() => CustomImageUploader(
                      selectedImage: controller
                          .userRegController?.drivingLicenseBackIdImage.value,
                      onImageSourceSelected: (source) =>
                          controller.pickImage(source, false),
                      height: 150,
                      fieldName: "DrivingLicense.FrontSideImageUrl",
                      error: controller.userRegController?.errorValidation ??
                          getNonNullResponse(),
                    )),
                const SizedBox(height: 30),
                Obx(() => CustomElevatedButton(
                      text: 'Save',
                      // onPressed: controller.canProceed.value ? controller.onNextPressed : null,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.onNextPressed,
                      isLoading: controller.isLoading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
