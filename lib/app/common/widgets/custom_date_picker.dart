import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String fieldName;
  final Rx<ErrorResponse?> error;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    this.hintText = 'Date',
    this.icon = Icons.calendar_today,
    required this.fieldName,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () async {
        DateTime initialDate;
        try {
          initialDate = DateTime.parse(controller.text);
        } catch (e) {
          initialDate = DateTime.now();
        }

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.grey,
                hintColor: Colors.grey,
                colorScheme: ColorScheme.light(primary: primaryColor),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child ?? Container(),
            );
          },
        );
        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            child: CustomTextField(
              hintText: hintText,
              icon: icon,
              controller: controller,
              keyboardType: TextInputType.datetime,
              fieldName: fieldName,
              error: error,
            ),
          ),

          // Error handling jika ada error
          if (error.value != null && error.value!.errors != null) ...[
            const SizedBox(height: 5),
            for (var err in error.value!.errors!) ...[
              if (err.propertyName
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
                        err.errorMessage,
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



// import 'package:flutter/material.dart';
// import 'package:santai_technician/app/common/widgets/custom_text_field.dart';

// class CustomDatePicker extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData icon;

//   const CustomDatePicker({
//     Key? key,
//     required this.controller,
//     this.hintText = 'Date',
//     this.icon = Icons.calendar_today,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     final Color primaryColor = Theme.of(context).colorScheme.primary;

//     return GestureDetector(
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(1900),
//           lastDate: DateTime.now(),
//           builder: (BuildContext context, Widget? child) {
//             return Theme(
//               data: ThemeData.light().copyWith(
//                 primaryColor: Colors.grey,
//                 hintColor: Colors.grey,
//                 colorScheme: ColorScheme.light(primary: primaryColor),
//                 buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//               ),
//               child: child ?? Container(),
//             );
//           },
//         );
//         if (pickedDate != null) {
//           String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
//           controller.text = formattedDate;
//         }
//       },
//       child: AbsorbPointer(
//         child: CustomTextField(
//           hintText: hintText,
//           icon: icon,
//           controller: controller,
//           keyboardType: TextInputType.datetime,
//         ),
//       ),
//     );
//   }
// }