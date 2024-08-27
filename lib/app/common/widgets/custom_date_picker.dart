import 'package:flutter/material.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    this.hintText = 'Date',
    this.icon = Icons.calendar_today,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.grey,
                hintColor: Colors.grey,
                colorScheme: ColorScheme.light(primary: primaryColor),
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child ?? Container(),
            );
          },
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
          controller.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: CustomTextField(
          hintText: hintText,
          icon: icon,
          controller: controller,
          keyboardType: TextInputType.datetime,
        ),
      ),
    );
  }
}