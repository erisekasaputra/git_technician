class ProfileUserResponse {
  final bool isSuccess;
  final ProfileUserDataResponse? data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  ProfileUserResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class ProfileUserDataResponse {
  final String id;
  final String? email;
  final String? phoneNumber;
  final String timeZoneId;
  final ProfileAddressDataResponse address;
  final LoyaltyProgramDataResponse loyaltyProgram;
  final ReferralDataResponse? referral;
  final ProfilePersonalInfoDataResponse personalInfo;
  final List<CertificationDataResponse>? certifications;
  final DrivingLicenseDataResponse? drivingLicense;
  final NationalIdentityDataResponse? nationalIdentity;
  final double rating;
  final DateTime createdAt;
  final int totalEntireJob;
  final int totalCancelledJob;
  final int totalEntireJobBothCompleteIncomplete;
  final int totalCompletedJob;
  ProfileUserDataResponse(
      {required this.id,
      this.email,
      required this.phoneNumber,
      required this.timeZoneId,
      required this.address,
      required this.loyaltyProgram,
      required this.referral,
      required this.personalInfo,
      required this.certifications,
      required this.drivingLicense,
      required this.nationalIdentity,
      required this.rating,
      required this.createdAt,
      required this.totalEntireJob,
      required this.totalCancelledJob,
      required this.totalEntireJobBothCompleteIncomplete,
      required this.totalCompletedJob});
}

class ProfilePersonalInfoDataResponse {
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String? dateOfBirth;
  final String gender;
  final String? profilePicture;

  ProfilePersonalInfoDataResponse({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.dateOfBirth,
    required this.gender,
    this.profilePicture,
  });
}

class ProfileAddressDataResponse {
  final String addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  ProfileAddressDataResponse({
    required this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}

class LoyaltyProgramDataResponse {
  final String userId;
  final int points;
  final String tier;

  LoyaltyProgramDataResponse({
    required this.userId,
    required this.points,
    required this.tier,
  });
}

class ReferralDataResponse {
  final String referralCode;
  final int rewardPoint;

  ReferralDataResponse({
    required this.referralCode,
    required this.rewardPoint,
  });
}

class CertificationDataResponse {
  final String certificationId;
  final String certificationName;
  final DateTime? validDate;
  final List<String>? specialization;

  CertificationDataResponse({
    required this.certificationId,
    required this.certificationName,
    required this.validDate,
    required this.specialization,
  });
}

class DrivingLicenseDataResponse {
  final String id;
  final String licenseNumber;
  final String frontSideImageUrl;
  final String backSideImageUrl;

  DrivingLicenseDataResponse({
    required this.id,
    required this.licenseNumber,
    required this.frontSideImageUrl,
    required this.backSideImageUrl,
  });
}

class NationalIdentityDataResponse {
  final String id;
  final String identityNumber;
  final String frontSideImageUrl;
  final String backSideImageUrl;

  NationalIdentityDataResponse({
    required this.id,
    required this.identityNumber,
    required this.frontSideImageUrl,
    required this.backSideImageUrl,
  });
}
