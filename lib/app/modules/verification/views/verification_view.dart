import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/verification_controller.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              CustomProgressIndicator(
                totalSteps: 5,
                currentStep: 3,
                activeColor: primary_300,
                inactiveColor: Colors.grey[300]!,
                height: 3,
                spacing: 4,
              ),
              const SizedBox(height: 20),
              const Text(
                'To continue, We need to verify your identity',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey[300],
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 30),
              _buildInfoItem(
                icon: Icons.camera_alt,
                title: 'Fast and Secure',
                description: 'This only takes a couple of minutes and is protected with encryption',
                color: primary_300,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                icon: Icons.camera_alt,
                title: 'Data used to verify you',
                description: 'Information you provide, data about your device and your behaviour',
                color: primary_300,
              ),
              const Spacer(),
              const Text(
                'By pressing "next" you agree to the Terms & Conditions',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
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

  Widget _buildInfoItem({required IconData icon, required String title, required String description, required Color color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(color: Colors.black, fontSize: 18)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
