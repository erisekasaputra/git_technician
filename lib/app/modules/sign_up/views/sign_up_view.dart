import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_phone_field.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/common/widgets/custom_pswd_field.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
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
                  fieldName: "PhoneNumber",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Password',
                ),
                const SizedBox(height: 5),
                CustomPasswordField(
                  controller: controller.passwordController,
                  isPasswordHidden: controller.isPasswordHidden,
                  fieldName: "Password",
                  error: controller.errorValidation,
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
                                fontFamily: 'Saira',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: "I agree to the "),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary_100,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: Get.context!,
                                        builder: (context) =>
                                            _buildTermsAndCondition(context),
                                      );
                                    },
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary_100,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: Get.context!,
                                        builder: (context) =>
                                            _buildPrivacyPolicy(context),
                                      );
                                    },
                                ),
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
                          : (controller.isAgreed.value
                              ? controller.signUp
                              : null),
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // Card(
                //     //   color: Colors.white,
                //     //   shape: RoundedRectangleBorder(
                //     //     side: BorderSide(color: borderColor, width: 1),
                //     //     borderRadius: BorderRadius.circular(8),
                //     //   ),
                //     //   child: IconButton(
                //     //     icon: Image.asset('assets/images/google_logo.png',
                //     //         width: 30, height: 30),
                //     //     onPressed: controller.signInWithGoogle,
                //     //   ),
                //     // ),
                //     // const SizedBox(width: 10),
                //     // Card(
                //     //   color: Colors.white,
                //     //   shape: RoundedRectangleBorder(
                //     //     side: BorderSide(color: borderColor, width: 1),
                //     //     borderRadius: BorderRadius.circular(8),
                //     //   ),
                //     //   child: IconButton(
                //     //     icon: Image.asset('assets/images/facebook_logo.png', width: 30, height: 30),
                //     //     onPressed: controller.signInWithGoogle,
                //     //   ),
                //     // ),
                //   ],
                // ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Teks reguler awal
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Saira',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      // "Sign Up" dengan gaya bold dan warna biru
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              Routes.LOGIN); // Aksi saat "Sign Up" di klik
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Saira',
                            fontWeight: FontWeight
                                .w700, // Bold lebih tebal untuk penekanan
                            color: Colors
                                .blueAccent, // Garis bawah untuk gaya interaktif
                          ),
                        ),
                      ),
                      // Tambahan spasi kecil agar tidak terlalu dekat
                      const SizedBox(width: 4),
                      // Teks reguler akhir
                      const Text(
                        "with mobile phone",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Saira',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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

  Widget _buildPrivacyPolicy(BuildContext context) {
    return AlertDialog(
      title: const Text("Privacy Policy"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 1, // 50% dari tinggi layar
        width: MediaQuery.of(context).size.width * 1, // 80% dari lebar layar
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.privacyPolicy.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildTermsAndCondition(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Terms & Conditions",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height, // 60% dari tinggi layar
        width: MediaQuery.of(context).size.width, // 90% dari lebar layar
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MarkdownBody(
              data: controller.termsAndCondition.value,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
