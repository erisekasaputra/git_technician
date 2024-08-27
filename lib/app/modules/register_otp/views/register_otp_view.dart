import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/register_otp_controller.dart';

class RegisterOtpView extends GetView<RegisterOtpController> {
  const RegisterOtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final Color color_primary_50 = Theme.of(context).colorScheme.primary_50;
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'OTP Verification',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We have sent an OTP code to your phone',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'contact@santaitechnology.com',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Enter the OTP code below to verify.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => SizedBox(
                        width: 60,
                        child: TextField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: borderColor, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            controller.updateOtpDigit(index, value);
                            if (value.length == 1 && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                   Obx(() => Text(
                      controller.canResend.value
                            ? ''
                            : 'Did not receive the code? You can resend in ${controller.resendTimer.value}s',
                      style: TextStyle(fontSize: 14, color: color_primary_50),
                    )),

                    const SizedBox(height: 20),
                     Obx(() => ElevatedButton.icon(
                      icon: const Icon(Icons.call, color: Colors.white),
                      label: Text(
                        controller.isLoadingWhatsApp.value ? 'Sending...' : 'Send OTP via WhatsApp',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: (controller.isLoadingWhatsApp.value || !controller.canResend.value) ? null : controller.sendOtpViaWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                    const SizedBox(height: 10),
                    Obx(() => ElevatedButton.icon(
                      icon: const Icon(Icons.sms, color: Colors.white),
                      label: Text(
                        controller.isLoadingSms.value ? 'Sending...' : 'Send OTP via SMS',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: (controller.isLoadingSms.value || !controller.canResend.value) ? null : controller.sendOtpViaSms,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
