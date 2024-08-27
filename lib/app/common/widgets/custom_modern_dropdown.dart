import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class ModernDropdown extends StatelessWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;
  final double? width;
  final IconData prefixIcon; // Add this line

  const ModernDropdown({
    Key? key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
    this.width,
    this.prefixIcon = Icons.arrow_drop_down, // Add this line with a default icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return SizedBox(
      width: width,
      height: 60,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          menuProps: MenuProps(
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          showSelectedItems: true,
          containerBuilder: (context, popupWidget) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: popupWidget,
            );
          },
        ),
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            prefixIcon: Icon(prefixIcon), // Add this line
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
            hintText: hintText,
          ),
        ),
        onChanged: onChanged,
        selectedItem: selectedItem,
      ),
    );
  }
}