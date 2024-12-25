import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String, String, String) onChanged;
  final String fieldName;

  final Rx<ErrorResponse?> error;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.hintText = 'Phone Number',
    required this.onChanged,
    this.fieldName = "PhoneNumber",
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    var filteredCountries =
        countries.where((element) => ['MY'].contains(element.code)).toList();

    return Obx(
      () => Column(
        children: [
          IntlPhoneField(
            invalidNumberMessage: '',
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                  color: Color(0xFF818898),
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.4)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null) {
                return 'Please enter a phone number';
              }
              if (value.completeNumber.isEmpty ||
                  value.countryCode.isEmpty ||
                  value.countryISOCode.isEmpty) {
                return 'Invalid phone number format';
              }
              return null;
            },
            initialCountryCode: 'MY',
            countries: filteredCountries,
            onChanged: (phone) {
              onChanged(phone.countryISOCode, phone.countryCode, phone.number);
            },
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black87,
            ),
            pickerDialogStyle: PickerDialogStyle(
              width: MediaQuery.of(context).size.width,
              backgroundColor: Colors.white,
              countryNameStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.black87, // Modern font style for country names
              ),
              listTilePadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              padding: const EdgeInsets.all(10),
              listTileDivider: Divider(
                height: 0.0,
                color: Colors.grey.withOpacity(0.1),
                thickness: 0, // Subtle divider to separate the country list
              ),
              countryCodeStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xFF818898), // Modern font style for country names
              ),
              searchFieldCursorColor: Colors.blue,
              searchFieldInputDecoration: InputDecoration(
                hintText: 'Search Country...',
                hintStyle: TextStyle(
                    fontSize: 13, color: Colors.grey.withOpacity(0.7)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.blueGrey.withOpacity(0.4)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.blueGrey.withOpacity(0.4)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.blueGrey.withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            enabled: true,
          ),
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
