import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isPasswordHidden;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.isPasswordHidden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Obx(() => TextField(
      controller: controller,
      obscureText: isPasswordHidden.value,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(isPasswordHidden.value ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            isPasswordHidden.value = !isPasswordHidden.value;
          },
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
      ),
    ));
  }
}