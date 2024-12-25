import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isPasswordHidden;
  final String fieldName;
  final bool isNew;
  final Rx<ErrorResponse?> error;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.isPasswordHidden,
    this.fieldName = "Password",
    this.isNew = false,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password TextField
          TextField(
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Saira',
            ),
            controller: controller,
            obscureText: isPasswordHidden.value,
            decoration: InputDecoration(
              hintStyle:
                  const TextStyle(fontSize: 13, color: Color(0xFF818898)),
              hintText: isNew ? 'New Password' : 'Password',
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF818898)),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordHidden.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: const Color(0xFF818898),
                ),
                onPressed: () {
                  isPasswordHidden.value = !isPasswordHidden.value;
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
          ),

          if (error.value != null && error.value!.errors != null) ...[
            const SizedBox(height: 5),
            for (var error in error.value!.errors!) ...[
              if (error.propertyName
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Expanded(
                      child: Text(
                        error.errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ]
            ]
          ],

          if (error.value != null && error.value!.validationErrors != null) ...[
            const SizedBox(height: 5),
            for (var entry in error.value!.validationErrors!.entries) ...[
              if (entry.key
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                for (var errorMessage in entry.value) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 5), // Space between icon and text
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ]
              ]
            ]
          ],
        ],
      ),
    );
  }
}
