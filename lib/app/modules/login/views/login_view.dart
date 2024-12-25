import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_phone_field.dart';
import 'package:santai_technician/app/common/widgets/custom_pswd_field.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.17,
                            child: Image.asset(
                              'assets/images/logo_hd_santaimoto_blue.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: constraints.maxHeight * 0.045,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Login to your account',
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              const CustomLabel(
                                text: 'Phone Number',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 5),
                              CustomPhoneField(
                                hintText: 'Enter Phone Number',
                                controller: controller.phoneController,
                                onChanged: controller.updatePhoneInfo,
                                error: controller.errorValidation,
                              ),
                              const CustomLabel(
                                text: 'Password',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 5),
                              CustomPasswordField(
                                controller: controller.passwordController,
                                isPasswordHidden: controller.isPasswordHidden,
                                fieldName: "Password",
                                error: controller.errorValidation,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.FORGOT_PASSWORD);
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              CustomElevatedButton(
                                text: 'Log In',
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.login,
                                isLoading: controller.isLoading.value,
                                height: 48,
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey, // Line color
                                      thickness: 1, // Line thickness
                                      indent: 3, // Left space before line
                                      endIndent: 15, // Right space after line
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Or',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      indent: 15,
                                      endIndent: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Dont have an Account ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Saira',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.SIGN_UP);
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Saira',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "with mobile phone",
                                  style: TextStyle(
                                    fontSize: 13,
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
              ),
              // Sticky icon on top-right corner
            ],
          );
        }),
      ),
    );
  }
}
