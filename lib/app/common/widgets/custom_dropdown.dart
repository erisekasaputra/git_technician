import 'package:flutter/material.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;
  final IconData icon;
  final double? width;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
    this.icon = Icons.arrow_drop_down,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
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
        value: value,
        hint: Text(hintText, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}