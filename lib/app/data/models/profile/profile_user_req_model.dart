import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';

class ProfileUserReqModel extends ProfileUserRequest {
  ProfileUserReqModel(
      {required super.timeZoneId,
      super.referralCode,
      required ProfileAddressReqModel super.address,
      required ProfilePersonalInfoReqModel super.personalInfo,
      required List<CertificationReqModel> super.certifications,
      required DrivingLicenseReqModel super.drivingLicense,
      required NationalIdentityReqModel super.nationalIdentity});

  factory ProfileUserReqModel.fromEntity(ProfileUserRequest profileUser) {
    return ProfileUserReqModel(
      timeZoneId: profileUser.timeZoneId,
      referralCode: profileUser.referralCode,
      address: ProfileAddressReqModel.fromEntity(profileUser.address),
      personalInfo:
          ProfilePersonalInfoReqModel.fromEntity(profileUser.personalInfo),
      certifications: profileUser.certifications
          .map((cert) => CertificationReqModel.fromEntity(cert))
          .toList(),
      drivingLicense:
          DrivingLicenseReqModel.fromEntity(profileUser.drivingLicense),
      nationalIdentity:
          NationalIdentityReqModel.fromEntity(profileUser.nationalIdentity),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeZoneId': timeZoneId,
      'referralCode': referralCode,
      'address': (address as ProfileAddressReqModel).toJson(),
      'personalInfo': (personalInfo as ProfilePersonalInfoReqModel).toJson(),
      'certifications': certifications
          .map((cert) => (cert as CertificationReqModel).toJson())
          .toList(),
      'drivingLicense': (drivingLicense as DrivingLicenseReqModel).toJson(),
      'nationalIdentity':
          (nationalIdentity as NationalIdentityReqModel).toJson(),
    };
  }
}

class ProfileAddressReqModel extends ProfileAddressRequest {
  ProfileAddressReqModel({
    required super.addressLine1,
    super.addressLine2,
    super.addressLine3,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
  });

  factory ProfileAddressReqModel.fromEntity(ProfileAddressRequest address) {
    return ProfileAddressReqModel(
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      addressLine3: address.addressLine3,
      city: address.city,
      state: address.state,
      postalCode: address.postalCode,
      country: address.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}

class ProfilePersonalInfoReqModel extends ProfilePersonalInfoRequest {
  ProfilePersonalInfoReqModel({
    required super.firstName,
    super.middleName,
    super.lastName,
    required super.dateOfBirth,
    required super.gender,
    super.profilePictureUrl,
  });

  factory ProfilePersonalInfoReqModel.fromEntity(
      ProfilePersonalInfoRequest personalInfo) {
    return ProfilePersonalInfoReqModel(
      firstName: personalInfo.firstName,
      middleName: personalInfo.middleName,
      lastName: personalInfo.lastName,
      dateOfBirth: personalInfo.dateOfBirth,
      gender: personalInfo.gender,
      profilePictureUrl: personalInfo.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

class CertificationReqModel extends CertificationRequest {
  CertificationReqModel({
    required super.certificationId,
    required super.certificationName,
    super.validDate,
    required super.specialization,
  });

  factory CertificationReqModel.fromEntity(CertificationRequest certification) {
    return CertificationReqModel(
      certificationId: certification.certificationId,
      certificationName: certification.certificationName,
      validDate: certification.validDate,
      specialization: certification.specialization,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificationId': certificationId,
      'certificationName': certificationName,
      'validDate': validDate?.toIso8601String(),
      'specialization': specialization,
    };
  }
}

class DrivingLicenseReqModel extends DrivingLicenseRequest {
  DrivingLicenseReqModel(
      {required super.licenseNumber,
      required super.frontSideImageUrl,
      required super.backSideImageUrl});

  factory DrivingLicenseReqModel.fromEntity(
      DrivingLicenseRequest certification) {
    return DrivingLicenseReqModel(
        licenseNumber: certification.licenseNumber,
        frontSideImageUrl: certification.frontSideImageUrl,
        backSideImageUrl: certification.backSideImageUrl);
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseNumber': licenseNumber,
      'frontSideImageUrl': frontSideImageUrl,
      'backSideImageUrl': backSideImageUrl
    };
  }
}

class NationalIdentityReqModel extends NationalIdentityRequest {
  NationalIdentityReqModel(
      {required super.identityNumber,
      required super.frontSideImageUrl,
      required super.backSideImageUrl});

  factory NationalIdentityReqModel.fromEntity(
      NationalIdentityRequest certification) {
    return NationalIdentityReqModel(
        identityNumber: certification.identityNumber,
        frontSideImageUrl: certification.frontSideImageUrl,
        backSideImageUrl: certification.backSideImageUrl);
  }

  Map<String, dynamic> toJson() {
    return {
      'identityNumber': identityNumber,
      'frontSideImageUrl': frontSideImageUrl,
      'backSideImageUrl': backSideImageUrl
    };
  }
}
