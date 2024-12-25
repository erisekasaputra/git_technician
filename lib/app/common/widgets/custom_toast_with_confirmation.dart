import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToastWithConfirmation {
  static void show({
    required String title,
    required String message,
    required String titleFirstButton,
    required Color colorFirstButton,
    required String titleSecondButton,
    required Color colorSecondButton,
    required Future<void> Function() onAccept,
    required Future<void> Function() onReject,
  }) {
    bool isProcessing = false; // State to handle loading

    Get.snackbar(
      "", // Title and message handled by custom widgets
      "",
      snackPosition: SnackPosition.BOTTOM,
      duration: null, // Persistent until manually closed
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      titleText: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      messageText: StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorFirstButton),
                  onPressed: isProcessing
                      ? null
                      : () async {
                          setState(() => isProcessing = true); // Start loading
                          try {
                            await onAccept(); // Call accept function
                            Get.closeCurrentSnackbar(); // Close Snackbar
                          } catch (_) {
                          } finally {
                            setState(
                                () => isProcessing = false); // Stop loading
                          }
                        },
                  child: isProcessing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(titleFirstButton),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecondButton),
                  onPressed: isProcessing
                      ? null
                      : () async {
                          setState(() => isProcessing = true); // Start loading
                          try {
                            await onReject(); // Call reject function
                            Get.closeCurrentSnackbar(); // Close Snackbar
                          } catch (_) {
                          } finally {
                            setState(
                                () => isProcessing = false); // Stop loading
                          }
                        },
                  child: isProcessing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(titleSecondButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
