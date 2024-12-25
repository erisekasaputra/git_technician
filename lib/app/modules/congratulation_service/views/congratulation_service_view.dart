import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/congratulation_service_controller.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CongratulationServiceView
    extends GetView<CongratulationServiceController> {
  const CongratulationServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color success_300 = Theme.of(context).colorScheme.success_300;
    final Color errorColor = Theme.of(context).colorScheme.error;
    final Color borderInput_01 = Theme.of(context).colorScheme.borderInput_01;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Service ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: controller.isSuccess.value
                            ? 'Completed'
                            : 'Incompleted',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: controller.isSuccess.value
                              ? success_300
                              : errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Obx(() {
                if (controller.isSuccess.value) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: success_300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 70,
                      weight: 40,
                    ),
                  );
                }

                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: errorColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 70,
                    weight: 40,
                  ),
                );
              }),
              const SizedBox(height: 60),
              const Text(
                'You will be redirected to the home screen automatically or click below to return to home screen one activated.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: controller.returnToHomeScreen,
                style: TextButton.styleFrom(
                  backgroundColor: primary_300,
                  side: BorderSide(color: borderInput_01, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Return to Home Screen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
