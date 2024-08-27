import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_phone_field.dart';
import 'package:santai_technician/app/common/widgets/custom_pswd_field.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

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
                const SizedBox(height: 50),
                Image.asset('assets/images/company_logo.png', width: 200, height: 200),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Obx(() => Column(
                  children: [
                    if (controller.isStaffLogin.value) ...[
                      const SizedBox(height: 10),
                      const CustomLabel(text: 'Business Code'),
                      const SizedBox(height: 5),
                      CustomTextField(
                        controller: controller.businessCodeController,
                        hintText: 'Enter business code',
                        icon: Icons.business_center,
                      ),
                    ],
                    const SizedBox(height: 10),
                    const CustomLabel(text: 'Phone'),
                    const SizedBox(height: 5),
                    CustomPhoneField(
                      hintText: 'Enter your phone number',
                      controller: controller.phoneController,
                      onChanged: controller.updatePhoneInfo,
                    ),
                    const CustomLabel(text: 'Password'),
                    const SizedBox(height: 5),
                    CustomPasswordField(
                      controller: controller.passwordController,
                      isPasswordHidden: controller.isPasswordHidden,
                    ),
                    
                  ],
                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => CustomElevatedButton(
                  text: controller.isStaffLogin.value ? 'Staff Log In' : 'Log In',
                  onPressed: controller.isLoading.value
                    ? null
                    : (controller.isStaffLogin.value ? controller.signInAsStaff : controller.login),
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
                        style: TextStyle(fontSize: 16),
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
                    Column(
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
                        // const Text('Sign in with Google'),
                      ],
                    ),
                    // const SizedBox(width: 10),
                    // Column(
                    //   children: [
                    //     Card(
                    //       color: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         side: BorderSide(color: borderColor, width: 1),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: IconButton(
                    //         icon: Image.asset('assets/images/facebook_logo.png', width: 30, height: 30),
                    //         onPressed: controller.signInWithGoogle,
                    //       ),
                    //     ),
                    //     // const Text('Sign in with Facebook'),
                    //   ],
                    // ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: borderColor, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.business_center, size: 30, color: Colors.black),
                            onPressed: controller.toggleStaffLogin,
                          ),
                        ),
                        // Obx(() => Text(controller.isStaffLogin.value ? 'Switch to User' : 'Sign in as Staff')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.SIGN_UP);
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
                              TextSpan(text: "Sign Up ", style: TextStyle(color: Theme.of(context).colorScheme.primary_100)),
                              const TextSpan(text: "with mobile phone"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
