import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_date_picker.dart';
import 'package:santai_technician/app/common/widgets/custom_elvbtn_001.dart';
import 'package:santai_technician/app/common/widgets/custom_image_uploader.dart';
import 'package:santai_technician/app/common/widgets/custom_label_001.dart';
import 'package:santai_technician/app/common/widgets/custom_modern_dropdown.dart';
import 'package:santai_technician/app/common/widgets/custom_progress_indicator.dart';
import 'package:santai_technician/app/common/widgets/custom_text_field.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

import '../controllers/user_registration_controller.dart';

class UserRegistrationView extends GetView<UserRegistrationController> {
  const UserRegistrationView({super.key});
  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Obx(
                  () => controller.isUpdateMode.value
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 40),
                ),
                Obx(
                  () => controller.isUpdateMode.value
                      ? const SizedBox.shrink()
                      : CustomProgressIndicator(
                          totalSteps: 5,
                          currentStep: 2,
                          activeColor: primary_300,
                          inactiveColor: Colors.grey[300]!,
                          height: 3,
                          spacing: 4,
                        ),
                ),
                Obx(() => controller.isUpdateMode.value
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 20)),
                const SizedBox(height: 10),
                Obx(
                  () => CustomImageUploader(
                    selectedImage: controller.userImageProfileImage.value,
                    onImageSourceSelected: (source) =>
                        controller.pickImage(source),
                    height: 150,
                    fieldName: "PersonalInfo.ProfilePictureUrl",
                    error: controller.errorValidation,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => controller.isUpdateMode.value
                      ? const SizedBox.shrink()
                      : const CustomLabel(
                          text: 'Reference Code',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                ),
                const SizedBox(height: 5),
                Obx(() => controller.isUpdateMode.value
                    ? const SizedBox.shrink()
                    : CustomTextField(
                        hintText: 'Reference Code',
                        icon: Icons.code,
                        controller: controller.referenceCodeController,
                        readOnly: controller.isUpdateMode.value,
                        fieldName: "ReferenceCode",
                        error: controller.errorValidation,
                      )),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'First Name',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'First Name',
                  icon: null,
                  controller: controller.firstNameController,
                  fieldName: "PersonalInfo.FirstName",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Middle Name',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Middle Name',
                  icon: null,
                  controller: controller.middleNameController,
                  fieldName: "PersonalInfo.MiddleName",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Last Name',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Last Name',
                  icon: null,
                  controller: controller.lastNameController,
                  fieldName: "PersonalInfo.LastName",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(
                            text: 'Date of Birth',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 5),
                          CustomDatePicker(
                            hintText: 'Date of Birth',
                            controller: controller.dateOfBirthController,
                            fieldName: "PersonalInfo.DateOfBirth",
                            error: controller.errorValidation,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomLabel(
                            text: 'Gender',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 5),
                          Obx(
                            () => ModernDropdown(
                              selectedItem: controller.selectedGender.value,
                              items: controller.genderOptions,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controller.selectedGender.value = newValue;
                                }
                              },
                              prefixIcon: Icons.female_rounded,
                              hintText: 'Select Gender',
                              width: double.infinity,
                              fieldName: "PersonalInfo.Gender",
                              error: controller.errorValidation,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Country',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Country',
                  icon: Icons.pin_drop,
                  controller: controller.countryController,
                  fieldName: "Address.Country",
                  error: controller.errorValidation,
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'State',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                Obx(
                  () => ModernDropdown(
                    selectedItem: controller.selectedState.value,
                    items: controller.stateList,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedState.value = newValue;
                        controller.changeSelectedCities(newValue);
                      }
                    },
                    prefixIcon:
                        Icons.location_city_outlined, // maps_home_work_outlined
                    hintText: 'Select State',
                    width: double.infinity,
                    fieldName: "Address.State",
                    error: controller.errorValidation,
                  ),
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'City',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                Obx(
                  () => ModernDropdown(
                    selectedItem: controller.selectedCity.value,
                    items: controller.selectedStateCities,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedCity.value = newValue;
                      }
                    },
                    prefixIcon:
                        Icons.location_city_outlined, // maps_home_work_outlined
                    hintText: 'Select City',
                    width: double.infinity,
                    fieldName: "Address.City",
                    error: controller.errorValidation,
                  ),
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Address',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Address',
                  icon: Icons.location_city_outlined,
                  controller: controller.addressController,
                  fieldName: "Address.AddressLine1",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 10),
                const CustomLabel(
                  text: 'Postal Code',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Postal Code',
                  icon: Icons.numbers_outlined,
                  controller: controller.posCodeController,
                  keyboardType: TextInputType.number,
                  fieldName: "Address.PostalCode",
                  error: controller.errorValidation,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Obx(() => CustomElevatedButton(
                      text: controller.isUpdateMode.value ? 'Update' : 'Next',
                      onPressed: () async {
                        if (controller.isLoading.value) {
                          return;
                        }

                        if (controller.isUpdateMode.value) {
                          await controller.updateUser();
                          return;
                        }

                        await controller.next();
                      },
                      isLoading: controller.isLoading.value,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
