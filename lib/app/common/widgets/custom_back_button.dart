import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color effectiveBackgroundColor = Theme.of(context).colorScheme.primary_300;
    final Color effectiveBackgroundColor2 = Theme.of(context).colorScheme.primary_100;

    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      child: Container(
        width: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [effectiveBackgroundColor2, effectiveBackgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios, color: Colors.white, size: 20, weight: 4),
          ],
        ),
      ),
    );
  }
}