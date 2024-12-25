import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_pswd_field.dart';
import 'package:santai_technician/app/routes/app_pages.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
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
                        height: constraints.maxHeight * 0.15,
                        child: Image.asset(
                          'assets/images/logo_santaimoto_bluesquare.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: constraints.maxHeight * 0.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          CustomPasswordField(
                            controller: controller.newPasswordController,
                            isPasswordHidden: false.obs,
                            isNew: true,
                            fieldName: "Password",
                            error: controller.errorValidation,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        text: 'Change Password',
                        onPressed: controller.changePasswordAction,
                        isLoading: controller.isLoading.value,
                      ),
                      const SizedBox(height: 20),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Teks reguler awal
                            const Text(
                              "Remember you password? ",
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
                                Get.toNamed(Routes.LOGIN);
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
