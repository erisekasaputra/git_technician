import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastType { success, error, warning, info }

class CustomToast {
  static void show({
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
    double horizontalPadding = 8.0,
    double innerPadding = 4.0,
  }) {
    // Close any existing Snackbars to avoid stacking
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    // Ensure Get.context is not null before showing a Snackbar
    if (Get.context == null) {
      debugPrint("Snackbar context is null. Unable to show the toast.");
      return;
    }

    Color backgroundColor;
    IconData icon;

    // Map ToastType to colors and icons
    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    // Display the Snackbar using Get
    Get.snackbar(
      "",
      "",
      titleText: const SizedBox.shrink(),
      messageText: Padding(
        padding: EdgeInsets.all(innerPadding),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: 10), // Adjust margin
      borderRadius: 4,
      duration: duration,
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.zero, // Remove default padding
    );
  }
}
