class ProfileUserRequest {
  final String timeZoneId;
  final String? referralCode;
  final ProfileAddressRequest address;
  final ProfilePersonalInfoRequest personalInfo;
  List<CertificationRequest> certifications;
  DrivingLicenseRequest drivingLicense;
  NationalIdentityRequest nationalIdentity;

  ProfileUserRequest(
      {required this.timeZoneId,
      this.referralCode,
      required this.address,
      required this.personalInfo,
      required this.certifications,
      required this.drivingLicense,
      required this.nationalIdentity});
}

class ProfileAddressRequest {
  final String addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ProfileAddressRequest({
    required this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}

class ProfilePersonalInfoRequest {
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String? dateOfBirth;
  final String gender;
  final String? profilePictureUrl;

  ProfilePersonalInfoRequest({
    required this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    required this.gender,
    this.profilePictureUrl,
  });
}

class CertificationRequest {
  final String certificationId;
  final String certificationName;
  final DateTime? validDate;
  final List<String>? specialization;

  CertificationRequest(
      {required this.certificationId,
      required this.certificationName,
      required this.validDate,
      required this.specialization});
}

class DrivingLicenseRequest {
  final String licenseNumber;
  final String frontSideImageUrl;
  final String backSideImageUrl;

  DrivingLicenseRequest(
      {required this.licenseNumber,
      required this.frontSideImageUrl,
      required this.backSideImageUrl});
}

class NationalIdentityRequest {
  final String identityNumber;
  final String frontSideImageUrl;
  final String backSideImageUrl;

  NationalIdentityRequest(
      {required this.identityNumber,
      required this.frontSideImageUrl,
      required this.backSideImageUrl});
}
