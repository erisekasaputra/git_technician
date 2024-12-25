import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.text = 'Back',
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        Theme.of(context).colorScheme.primary_300;

    return GestureDetector(
      onTap: onPressed ??
          () {
            if (Get.isDialogOpen ?? false) {
              Get.back();
            } else {
              Get.back(closeOverlays: true);
            }
          },
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(text == 'Back' ? Icons.arrow_back : Icons.arrow_right,
                color: Colors.white, size: 16, weight: 2),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
