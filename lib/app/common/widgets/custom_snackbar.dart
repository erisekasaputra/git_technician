import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning, info }

class ModernSnackbar {
  static void show({
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    IconData icon;
    Color color;

    switch (type) {
      case SnackbarType.success:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case SnackbarType.error:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case SnackbarType.warning:
        icon = Icons.warning_amber_outlined;
        color = Colors.orange;
        break;
      case SnackbarType.info:
        icon = Icons.info_outline;
        color = Colors.blue;
        break;
    }

    Get.snackbar(
      '',
      '',
      titleText: Container(),
      messageText: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 5), 
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), 
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}




// ModernSnackbar.show(
//   message: "Operation completed successfully!",
//   type: SnackbarType.success,
// );


// ModernSnackbar.show(
//   message: "An error occurred. Please try again.",
//   type: SnackbarType.error,
// );


// ModernSnackbar.show(
//   message: "Please be cautious with this action.",
//   type: SnackbarType.warning,
// );


// ModernSnackbar.show(
//   message: "Here's some useful information for you.",
//   type: SnackbarType.info,
// );