import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';
import 'package:santai_technician/app/domain/entities/profile/update_profile_user_req.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/domain/usecases/profile/insert_profile_user.dart';
import 'package:santai_technician/app/domain/usecases/profile/update_user_profile.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/settings/controllers/settings_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/image_uploader.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/services/timezone_service.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class UserRegistrationController extends GetxController {
  final SettingsController? settingController =
      Get.isRegistered<SettingsController>()
          ? Get.find<SettingsController>()
          : null;

  final Logout logout = Logout();
  late ProfileUserRequest draftProfileUser;
  final SessionManager sessionManager = SessionManager();
  final TimezoneService timezoneService = TimezoneService();

  final userImageProfileImage = Rx<File?>(null);
  final userImageProfileResourceName = ''.obs;

  final nationalIdentityFrontIdImage = Rx<File?>(null);
  final nationalIdentityFrontResourceName = ''.obs;
  final nationalIdentityBackIdImage = Rx<File?>(null);
  final nationalIdentityBackResourceName = ''.obs;

  final drivingLicenseFrontIdImage = Rx<File?>(null);
  final drivingLicenseFrontResourceName = ''.obs;
  final drivingLicenseBackIdImage = Rx<File?>(null);
  final drivingLicenseBackResourceName = ''.obs;

  final isLoading = false.obs;
  final isUpdateMode = false.obs;

  TextEditingController referenceCodeController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController posCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final genderOptions = ['Male', 'Female'];
  final selectedGender = 'Male'.obs;

  final errorValidation = Rx<ErrorResponse?>(null);
  final ImageUploaderService _imageUploaderService = ImageUploaderService();

  final UserInsertProfile insertProfileUser;
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  final stateList = [
    "",
    "Johor",
    "Kedah",
    "Kelantan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perak",
    "Perlis",
    "Pulau Pinang",
    "Sarawak",
    "Selangor",
    "Terengganu",
    "Sabah",
    "Wilayah Persekutuan"
  ];

  final selectedStateCities = RxList<String>([""]);

  final stateCities = {
    "Johor": [
      "Johor Bahru",
      "Tebrau",
      "Pasir Gudang",
      "Bukit Indah",
      "Skudai",
      "Kluang",
      "Batu Pahat",
      "Muar",
      "Ulu Tiram",
      "Senai",
      "Segamat",
      "Kulai",
      "Kota Tinggi",
      "Pontian Kechil",
      "Tangkak",
      "Bukit Bakri",
      "Yong Peng",
      "Pekan Nenas",
      "Labis",
      "Mersing",
      "Simpang Renggam",
      "Parit Raja",
      "Kelapa Sawit",
      "Buloh Kasap",
      "Chaah"
    ],
    "Kedah": [
      "Sungai Petani",
      "Alor Setar",
      "Kulim",
      "Jitra / Kubang Pasu",
      "Baling",
      "Pendang",
      "Langkawi",
      "Yan",
      "Sik",
      "Kuala Nerang",
      "Pokok Sena",
      "Bandar Baharu"
    ],
    "Kelantan": [
      "Kota Bharu",
      "Pangkal Kalong",
      "Tanah Merah",
      "Peringat",
      "Wakaf Baru",
      "Kadok",
      "Pasir Mas",
      "Gua Musang",
      "Kuala Krai",
      "Tumpat"
    ],
    "Melaka": [
      "Bandaraya Melaka",
      "Bukit Baru",
      "Ayer Keroh",
      "Klebang",
      "Masjid Tanah",
      "Sungai Udang",
      "Batu Berendam",
      "Alor Gajah",
      "Bukit Rambai",
      "Ayer Molek",
      "Bemban",
      "Kuala Sungai Baru",
      "Pulau Sebang",
      "Jasin"
    ],
    "Negeri Sembilan": [
      "Seremban",
      "Port Dickson",
      "Nilai",
      "Bahau",
      "Tampin",
      "Kuala Pilah"
    ],
    "Pahang": [
      "Kuantan",
      "Temerloh",
      "Bentong",
      "Mentakab",
      "Raub",
      "Jerantut",
      "Pekan",
      "Kuala Lipis",
      "Bandar Jengka",
      "Bukit Tinggi"
    ],
    "Perak": [
      "Ipoh",
      "Taiping",
      "Sitiawan",
      "Simpang Empat",
      "Teluk Intan",
      "Batu Gajah",
      "Lumut",
      "Kampung Koh",
      "Kuala Kangsar",
      "Sungai Siput Utara",
      "Tapah",
      "Bidor",
      "Parit Buntar",
      "Ayer Tawar",
      "Bagan Serai",
      "Tanjung Malim",
      "Lawan Kuda Baharu",
      "Pantai Remis",
      "Kampar"
    ],
    "Perlis": ["Kangar", "Kuala Perlis"],
    "Pulau Pinang": [
      "Bukit Mertajam",
      "Georgetown",
      "Sungai Ara",
      "Gelugor",
      "Ayer Itam",
      "Butterworth",
      "Perai",
      "Nibong Tebal",
      "Permatang Kucing",
      "Tanjung Tokong",
      "Kepala Batas",
      "Tanjung Bungah",
      "Juru"
    ],
    "Sabah": [
      "Kota Kinabalu",
      "Sandakan",
      "Tawau",
      "Lahad Datu",
      "Keningau",
      "Putatan",
      "Donggongon",
      "Semporna",
      "Kudat",
      "Kunak",
      "Papar",
      "Ranau",
      "Beaufort",
      "Kinarut",
      "Kota Belud"
    ],
    "Sarawak": [
      "Kuching",
      "Miri",
      "Sibu",
      "Bintulu",
      "Limbang",
      "Sarikei",
      "Sri Aman",
      "Kapit",
      "Batu Delapan Bazaar",
      "Kota Samarahan"
    ],
    "Selangor": [
      "Subang Jaya",
      "Klang",
      "Ampang Jaya",
      "Shah Alam",
      "Petaling Jaya",
      "Cheras",
      "Kajang",
      "Selayang Baru",
      "Rawang",
      "Taman Greenwood",
      "Semenyih",
      "Banting",
      "Balakong",
      "Gombak Setia",
      "Kuala Selangor",
      "Serendah",
      "Bukit Beruntung",
      "Pengkalan Kundang",
      "Jenjarom",
      "Sungai Besar",
      "Batu Arang",
      "Tanjung Sepat",
      "Kuang",
      "Kuala Kubu Baharu",
      "Batang Berjuntai",
      "Bandar Baru Salak Tinggi",
      "Sekinchan",
      "Sabak",
      "Tanjung Karang",
      "Beranang",
      "Sungai Pelek",
      "Sepang",
    ],
    "Terengganu": [
      "Kuala Terengganu",
      "Chukai",
      "Dungun",
      "Kerteh",
      "Kuala Berang",
      "Marang",
      "Paka",
      "Jerteh"
    ],
    "Wilayah Persekutuan": ["Kuala Lumpur", "Labuan", "Putrajaya"]
  };

  final selectedState = ''.obs;
  final selectedCity = ''.obs;

  UserRegistrationController({
    required this.insertProfileUser,
    required this.getUserProfile,
    required this.updateUserProfile,
  });

  void changeSelectedCities(String state) {
    var cities = stateCities[state];
    selectedStateCities.removeWhere((item) => item.isNotEmpty);
    selectedCity.value = "";
    selectedCity.refresh();
    if (cities != null) {
      for (var city in cities) {
        selectedStateCities.add(city);
      }
    }
    selectedStateCities.refresh();
  }

  @override
  void onInit() async {
    super.onInit();
    final Map<String, dynamic>? args = Get.arguments;
    if (args != null && args['isUpdate'] == true) {
      isUpdateMode.value = true;
      loadUserData();
    }
    countryController.text = "Malaysia";
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      var userId = await sessionManager.getSessionBy(SessionManagerType.userId);
      var commonFileUrl =
          await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

      var userProfile = await getUserProfile(userId);

      if (userProfile == null || userProfile.data == null) {
        Get.back();
        return;
      }

      firstNameController.text = userProfile.data!.personalInfo.firstName;
      middleNameController.text =
          userProfile.data!.personalInfo.middleName ?? '';
      lastNameController.text = userProfile.data!.personalInfo.lastName ?? '';

      final DateTime? dateOfBirth =
          userProfile.data!.personalInfo.dateOfBirth == null
              ? null
              : DateTime.parse(userProfile.data!.personalInfo.dateOfBirth!);

      dateOfBirthController.text = dateOfBirth == null
          ? ''
          : "${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}";

      selectedGender.value = (userProfile.data!.personalInfo.gender
              .toLowerCase()[0]
              .toUpperCase() +
          userProfile.data!.personalInfo.gender.toLowerCase().substring(1));

      addressController.text = userProfile.data!.address.addressLine1;

      if (stateCities.containsKey(userProfile.data!.address.state)) {
        selectedState.value = userProfile.data!.address.state;
        changeSelectedCities(userProfile.data!.address.state);

        if (stateCities.containsKey(userProfile.data!.address.state) &&
            stateCities[userProfile.data!.address.state]!
                .contains(userProfile.data!.address.city)) {
          selectedCity.value = userProfile.data!.address.city;
        }
      }

      posCodeController.text = userProfile.data!.address.postalCode;
      countryController.text = userProfile.data!.address.country;

      if (userProfile.data!.personalInfo.profilePicture != null &&
          userProfile.data!.personalInfo.profilePicture!.isNotEmpty) {
        userImageProfileImage.value =
            await _imageUploaderService.downloadAndSetProfileImage(
                '$commonFileUrl${userProfile.data!.personalInfo.profilePicture}');
        userImageProfileResourceName.value =
            userProfile.data!.personalInfo.profilePicture!;
      }
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool validateFields({bool isWithImageValidation = true}) {
    if (firstNameController.text.isEmpty ||
        dateOfBirthController.text.isEmpty ||
        selectedGender.value.isEmpty ||
        addressController.text.isEmpty ||
        selectedCity.value.isEmpty ||
        selectedState.value.isEmpty ||
        posCodeController.text.isEmpty ||
        countryController.text.isEmpty) {
      return false;
    }
    if (isWithImageValidation) {
      if (draftProfileUser.drivingLicense.frontSideImageUrl.isEmpty ||
          draftProfileUser.drivingLicense.backSideImageUrl.isEmpty ||
          draftProfileUser.nationalIdentity.frontSideImageUrl.isEmpty ||
          draftProfileUser.nationalIdentity.backSideImageUrl.isEmpty) {
        return false;
      }
    }

    return true;
  }

  Future<void> next() async {
    try {
      String timezone = await timezoneService.getDeviceTimezone();

      draftProfileUser = ProfileUserRequest(
        timeZoneId: timezone,
        referralCode: referenceCodeController.text,
        address: ProfileAddressRequest(
          addressLine1: addressController.text,
          city: selectedCity.value,
          state: selectedState.value,
          postalCode: posCodeController.text,
          country: countryController.text,
        ),
        personalInfo: ProfilePersonalInfoRequest(
          firstName: firstNameController.text,
          middleName: middleNameController.text,
          lastName: lastNameController.text,
          dateOfBirth: dateOfBirthController.text.isEmpty
              ? null
              : dateOfBirthController.text,
          gender: selectedGender.value,
          profilePictureUrl: userImageProfileResourceName.value,
        ),
        certifications: [],
        drivingLicense: DrivingLicenseRequest(
            licenseNumber: '', frontSideImageUrl: '', backSideImageUrl: ''),
        nationalIdentity: NationalIdentityRequest(
            identityNumber: '', frontSideImageUrl: '', backSideImageUrl: ''),
      );

      Get.toNamed(Routes.VERIFICATION);
    } catch (e) {
      CustomToast.show(
          message: "Unknown error has occured", type: ToastType.error);
    }
  }

  Future<void> updateUser() async {
    try {
      var timezone =
          await sessionManager.getSessionBy(SessionManagerType.timeZone);
      var updatedUser = UpdateProfileUserReq(
        timeZoneId: timezone,
        address: ProfileAddressRequest(
          addressLine1: addressController.text.trim(),
          addressLine2: '',
          addressLine3: '',
          city: selectedCity.value,
          state: selectedState.value,
          postalCode: posCodeController.text.trim(),
          country: countryController.text.trim(),
        ),
        personalInfo: ProfilePersonalInfoRequest(
          firstName: firstNameController.text.trim(),
          middleName: middleNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          dateOfBirth: dateOfBirthController.text.isEmpty
              ? null
              : dateOfBirthController.text,
          gender: selectedGender.value.trim(),
          profilePictureUrl: userImageProfileResourceName.value,
        ),
      );

      var result = await updateUserProfile(updatedUser);
      if (result) {
        await sessionManager.updateSessionForProfile(
            userName:
                '${firstNameController.text.trim()}${middleNameController.text.trim()}${lastNameController.text.trim()}',
            timeZone: timezone,
            imageProfile: userImageProfileResourceName.value);

        settingController?.profileImageUrl.value =
            userImageProfileResourceName.value;
        settingController?.userName.value =
            '${firstNameController.text.trim()}${middleNameController.text.trim()}${lastNameController.text.trim()}';
        settingController?.profileImageUrl.refresh();
        settingController?.userName.refresh();

        Get.back();
        return;
      }

      CustomToast.show(
          message: 'Unable to update user profile', type: ToastType.error);
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, An unexpected error has occured",
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        userImageProfileImage.value = File(pickedFile.path);
        if (pickedFile.path.isNotEmpty) {
          userImageProfileResourceName.value =
              await _imageUploaderService.uploadImage(File(pickedFile.path));
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

  Future<void> register() async {
    isLoading.value = true;

    try {
      if (isUpdateMode.value) {
        // await updateProfileUser(profileUser);
      } else {
        var registerResult = await insertProfileUser(draftProfileUser);

        if (registerResult == null ||
            !registerResult.isSuccess ||
            registerResult.data == null) {
          return;
        }

        await sessionManager.registerSessionForProfile(
          userName:
              '${draftProfileUser.personalInfo.firstName} ${draftProfileUser.personalInfo.middleName ?? ''} ${draftProfileUser.personalInfo.lastName ?? ''}',
          timeZone: registerResult.data!.timeZoneId,
          phoneNumber: registerResult.data!.phoneNumber ?? '',
          imageProfile: registerResult.data!.personalInfo.profilePicture ?? '',
          referralCode: registerResult.data!.referral?.referralCode ?? '',
        );

        Get.offAllNamed(Routes.HOME);
      }
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          if (error.statusCode.isHttpResponseBadRequest()) {
            Get.toNamed(Routes.USER_REGISTRATION);
          }
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, An unexpected error has occured",
          type: ToastType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   referenceCodeController.dispose();
  //   firstNameController.dispose();
  //   middleNameController.dispose();
  //   lastNameController.dispose();
  //   phoneController.dispose();
  //   dateOfBirthController.dispose();
  //   genderController.dispose();
  //   addressController.dispose();
  //   posCodeController.dispose();
  //   super.onClose();
  // }
}
