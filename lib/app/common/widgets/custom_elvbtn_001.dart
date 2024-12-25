import 'package:flutter/material.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final double width;
  final double height;
  final bool isLoading;
  final Color? color;

  const CustomElevatedButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.textColor = Colors.white,
      this.fontSize = 16,
      this.fontWeight = FontWeight.bold,
      this.borderRadius = 20.0,
      this.width = double.infinity,
      this.height = 50.0,
      this.isLoading = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        color == null ? Theme.of(context).colorScheme.primary_300 : color!;

    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: effectiveBackgroundColor,
        disabledBackgroundColor: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
    );
  }
}
