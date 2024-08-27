import 'package:flutter/material.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomYearPicker extends StatelessWidget {
  final TextEditingController controller;
  final int startYear;
  final String hintText;

  const CustomYearPicker({
    Key? key,
    required this.controller,
    this.startYear = 1900,
    this.hintText = 'Year',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showYearPicker(context),
      child: AbsorbPointer(
        child: CustomTextField(
          hintText: hintText,
          icon: Icons.calendar_today,
          controller: controller,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Future<void> _showYearPicker(BuildContext context) async {

    final Color button_text_01 = Theme.of(context).colorScheme.button_text_01;
    final Color primary_100 = Theme.of(context).colorScheme.primary_100;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;


    final int currentYear = DateTime.now().year;
    final int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'SELECT YEAR',
              style: TextStyle(
                color: primary_300,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: primary_300, width: 2),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, 
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: currentYear - startYear + 1,
              itemBuilder: (BuildContext context, int index) {
                final int year = currentYear - index;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: primary_100,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(year),
                    child: Center(
                      child: Text(
                        year.toString(),
                        style: TextStyle(
                          color: button_text_01, 
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedYear != null) {
      controller.text = selectedYear.toString();
    }
  }
}