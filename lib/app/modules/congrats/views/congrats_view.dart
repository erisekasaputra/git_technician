import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/congrats_controller.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';

class CongratsView extends GetView<CongratsController> {
  const CongratsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verification Completed',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                    'assets/images/completed.png',
                    width: 300,
                    height: 300,
                  ),
              const Text(
                'You will be redirected to the home screen automatically or click for home screen',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                text: 'Next',
                onPressed: controller.isLoading.value ? null : controller.onNextPressed,
                  isLoading: controller.isLoading.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}