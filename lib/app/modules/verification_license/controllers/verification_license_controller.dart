import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';
import 'package:santai_technician/app/modules/user_registration/controllers/user_registration_controller.dart';
import 'package:santai_technician/app/services/image_uploader.dart';
import 'package:uuid/uuid.dart';

class VerificationLicenseController extends GetxController {
  final isLoading = false.obs;
  final canProceed = false.obs;
  final UserRegistrationController? userRegController =
      !Get.isRegistered<UserRegistrationController>()
          ? null
          : Get.find<UserRegistrationController>();
  final ImageUploaderService _imageUploaderService = ImageUploaderService();

  @override
  void onInit() {
    super.onInit();
    if (userRegController != null) {
      ever(userRegController!.drivingLicenseFrontIdImage,
          (_) => _updateCanProceed());
      ever(userRegController!.drivingLicenseBackIdImage,
          (_) => _updateCanProceed());
    }
  }

  void _updateCanProceed() {
    if (userRegController == null) {
      canProceed.value = false;
      return;
    }

    canProceed.value =
        userRegController!.drivingLicenseFrontIdImage.value != null &&
            userRegController!.drivingLicenseBackIdImage.value != null;
  }

  Future<void> pickImage(ImageSource source, bool isFrontImage) async {
    isLoading.value = true;
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        if (isFrontImage && userRegController != null) {
          userRegController!.drivingLicenseFrontIdImage.value =
              File(pickedFile.path);
          if (pickedFile.path.isNotEmpty) {
            userRegController!.drivingLicenseFrontResourceName.value =
                await _imageUploaderService.uploadImage(File(pickedFile.path));
          }
        }

        if (!isFrontImage && userRegController != null) {
          userRegController!.drivingLicenseBackIdImage.value =
              File(pickedFile.path);
          if (pickedFile.path.isNotEmpty) {
            userRegController!.drivingLicenseBackResourceName.value =
                await _imageUploaderService.uploadImage(File(pickedFile.path));
          }
        }
        CustomToast.show(
          message: "Image uploaded successfully",
          type: ToastType.success,
        );
      }
    } catch (e) {
      CustomToast.show(
        message: "Could not upload the image. Error: $e",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onNextPressed() async {
    _updateCanProceed();
    if (canProceed.value && userRegController != null) {
      userRegController!.draftProfileUser.drivingLicense =
          DrivingLicenseRequest(
              licenseNumber: (const Uuid()).v4(),
              frontSideImageUrl:
                  userRegController!.drivingLicenseFrontResourceName.value,
              backSideImageUrl:
                  userRegController!.drivingLicenseBackResourceName.value);
      await userRegController!.register();
    }
  }
}
