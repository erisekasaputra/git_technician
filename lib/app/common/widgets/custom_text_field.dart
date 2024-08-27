import 'package:flutter/material.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;  

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    // final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.black),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.black) : null, 
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
    );
  }
}