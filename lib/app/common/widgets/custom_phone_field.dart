import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String, String) onChanged;

  const CustomPhoneField({
    Key? key,
    required this.controller,
    this.hintText = 'Phone Number',
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;


    return IntlPhoneField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
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
      initialCountryCode: 'MY',
      onChanged: (phone) {
        onChanged(phone.countryCode, phone.number);
      },
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: Colors.white,
      ),
    );
  }
}