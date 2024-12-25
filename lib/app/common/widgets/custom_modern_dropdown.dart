import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class ModernDropdown extends StatelessWidget {
  final String selectedItem;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;
  final double? width;
  final IconData? prefixIcon;
  final String fieldName;
  final Rx<ErrorResponse?> error;

  const ModernDropdown({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select an option',
    this.width,
    this.prefixIcon,
    required this.fieldName,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      color: const Color(0xFF818898),
                      prefixIcon,
                      size: 24, // Adjust icon size if needed
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 13, // Font size for hint text
                fontWeight: FontWeight.w200,
              ),
              contentPadding: prefixIcon == null
                  ? const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal:
                          12) // Add horizontal padding when no prefixIcon
                  : const EdgeInsets.symmetric(
                      vertical:
                          15), // Default padding when prefixIcon is present
            ),
            value: selectedItem.isNotEmpty ? selectedItem : '',
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.isEmpty ? 'Select' : item,
                  style: const TextStyle(
                      fontSize: 13), // Font size of dropdown items
                ),
              );
            }).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_right_rounded), // Dropdown arrow icon
            dropdownColor: Colors.white, // Background color for dropdown items
            isExpanded: true,
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String item) {
                return Text(
                  item.isEmpty ? 'Select Item' : item,
                  overflow: TextOverflow
                      .ellipsis, // Apply ellipsis to handle overflow
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                );
              }).toList();
            },
          ),

          // Menambahkan error handling jika error ada
          if (error.value != null && error.value!.errors != null) ...[
            const SizedBox(height: 5),
            for (var error in error.value!.errors!) ...[
              if (error.propertyName
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Expanded(
                      child: Text(
                        error.errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ]
            ]
          ],

          if (error.value != null && error.value!.validationErrors != null) ...[
            const SizedBox(height: 5),
            for (var entry in error.value!.validationErrors!.entries) ...[
              if (entry.key
                  .toLowerCase()
                  .contains(fieldName.toLowerCase())) ...[
                for (var errorMessage in entry.value) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 5), // Space between icon and text
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ]
              ]
            ]
          ],
        ],
      ),
    );
  }
}
