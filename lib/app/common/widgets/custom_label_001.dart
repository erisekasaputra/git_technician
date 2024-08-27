import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomLabel({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: 'Saira',
        ),
      ),
    );
  }
}