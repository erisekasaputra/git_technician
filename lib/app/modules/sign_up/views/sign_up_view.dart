import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_phone_field.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/common/widgets/custom_pswd_field.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
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
                  currentStep: 1,
                  activeColor: primary_300,
                  inactiveColor: Colors.grey[300]!,
                  height: 3,
                  spacing: 4,
                ),
                const SizedBox(height: 20),
                const CustomLabel(
                  text: 'Phone',
                ),
                const SizedBox(height: 5),
                CustomPhoneField(
                  hintText: 'Enter your phone number',
                  controller: controller.phoneController,
                  onChanged: controller.updatePhoneInfo,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Password',
                ),
                const SizedBox(height: 5),
                 CustomPasswordField(
                  controller: controller.passwordController,
                  isPasswordHidden: controller.isPasswordHidden,
                ),
                const SizedBox(height: 20),
                Obx(() => Row(
                  children: [
                   Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (value) {
                        controller.isAgreed.value = value ?? false;
                      },
                      checkColor: Colors.white, 
                      activeColor: Colors.black,
                    ),
                    Expanded(
                      child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: "I agree to the "),
                              TextSpan(text: "Terms & Conditions", style: TextStyle(color: Theme.of(context).colorScheme.primary_100)),
                              const TextSpan(text: " and "),
                              TextSpan(text: "Privacy Policy", style: TextStyle(color: Theme.of(context).colorScheme.primary_100)),
                            ],
                          ),
                        ),
                    ),
                  ],
                )),

                const SizedBox(height: 10),
                Obx(() => CustomElevatedButton(
                  text: 'Create Account',
                  onPressed: controller.isLoading.value
                    ? null
                    : (controller.isAgreed.value ? controller.signUp : null),
                  isLoading: controller.isLoading.value,
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: borderColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset('assets/images/google_logo.png', width: 30, height: 30),
                        onPressed: controller.signInWithGoogle,
                      ),
                    ),
                    // const SizedBox(width: 10),
                    // Card(
                    //   color: Colors.white,
                    //   shape: RoundedRectangleBorder(
                    //     side: BorderSide(color: borderColor, width: 1),
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: IconButton(
                    //     icon: Image.asset('assets/images/facebook_logo.png', width: 30, height: 30),
                    //     onPressed: controller.signInWithGoogle,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You Have an Account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Sign In ", style: TextStyle(color: Theme.of(context).colorScheme.primary_100)),
                              const TextSpan(text: "with mobile phone"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
