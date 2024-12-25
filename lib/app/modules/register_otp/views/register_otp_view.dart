import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/register_otp_controller.dart';

class RegisterOtpView extends GetView<RegisterOtpController> {
  const RegisterOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color colorPrimary50 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the size dynamically based on available width
                double boxWidth = (constraints.maxWidth - 60) / 6;
                boxWidth =
                    boxWidth > 50 ? 50 : boxWidth; // Limit max width to 50

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'We have sent an OTP code to your Phone.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Enter the OTP code below to verify.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: boxWidth,
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Saira',
                              ),
                              controller: controller.controllers[index],
                              focusNode: controller.focusNodes[index],
                              maxLength: 2,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Saira',
                                ),
                                counterText: '', // Remove character counter
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 10,
                                    color: Colors.blue, // Default border color
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .blueAccent, // Darker blue when focused
                                  ),
                                ),
                              ),
                              onChanged: (value) =>
                                  controller.onTextChanged(index, value),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Text(
                          controller.canResend.value
                              ? ''
                              : 'Did not receive the code? You can resend in ${controller.resendTimer.value}s',
                          style: TextStyle(fontSize: 13, color: colorPrimary50),
                        )),
                    const SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton.icon(
                        icon: null,
                        label: Text(
                          controller.isLoadingSms.value
                              ? 'Requesting...'
                              : 'Request OTP',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: (controller.isLoadingSms.value ||
                                !controller.canResend.value)
                            ? null
                            : controller.sendOtpViaSms,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary50,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
