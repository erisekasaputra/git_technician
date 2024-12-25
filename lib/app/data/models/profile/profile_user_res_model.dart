import 'package:santai_technician/app/domain/entities/profile/profile_user_res.dart';

class ProfileUserResponseModel extends ProfileUserResponse {
  ProfileUserResponseModel({
    required super.isSuccess,
    required ProfileUserDataModel? data, // Nullable data parameter
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  }) : super(data: data);

  factory ProfileUserResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserResponseModel(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] != null
          ? ProfileUserDataModel.fromJson(json['data'])
          : null, // Set data to null if json['data'] is null
      message: json['message'] as String,
      responseStatus: json['responseStatus'] as String,
      errors: json['errors'] ?? [], // Default to empty list if null
      links: json['links'] ?? [], // Default to empty list if null
    );
  }
}

class ProfileUserDataModel extends ProfileUserDataResponse {
  ProfileUserDataModel(
      {required super.id,
      required super.email,
      required super.phoneNumber,
      required super.timeZoneId,
      required super.address,
      required super.loyaltyProgram,
      required super.referral,
      required super.personalInfo,
      required super.certifications,
      required super.drivingLicense,
      required super.nationalIdentity,
      required super.rating,
      required super.createdAt,
      required super.totalEntireJob,
      required super.totalCancelledJob,
      required super.totalEntireJobBothCompleteIncomplete,
      required super.totalCompletedJob});

  factory ProfileUserDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserDataModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      timeZoneId: json['timeZoneId'] as String,
      address: ProfileAddressModel.fromJson(json['address']),
      loyaltyProgram: LoyaltyProgramModel.fromJson(json['loyalty']),
      referral: json['referral'] == null
          ? null
          : ReferralModel.fromJson(json['referral']),
      personalInfo: ProfilePersonalInfoModel.fromJson(json['personalInfo']),
      certifications: json['certifications'] == null
          ? null
          : ((json['certifications'] as List<dynamic>?)
                  ?.map((item) => CertificationModel.fromJson(item))
                  .toList() ??
              []),
      drivingLicense: json['drivingLicense'] == null
          ? null
          : DrivingLicenseModel.fromJson(json['drivingLicense']),
      nationalIdentity: json['nationalIdentity'] == null
          ? null
          : NationalIdentityModel.fromJson(json['nationalIdentity']),
      rating: double.parse(json['rating'].toString()),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      totalEntireJob: int.parse(json['totalEntireJob'].toString()),
      totalCancelledJob: int.parse(json['totalCancelledJob'].toString()),
      totalEntireJobBothCompleteIncomplete:
          int.parse(json['totalEntireJobBothCompleteIncomplete'].toString()),
      totalCompletedJob: int.parse(json['totalCompletedJob'].toString()),
    );
  }
}

class ProfileAddressModel extends ProfileAddressDataResponse {
  ProfileAddressModel({
    required super.addressLine1,
    super.addressLine2,
    super.addressLine3,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
  });

  factory ProfileAddressModel.fromJson(Map<String, dynamic> json) {
    return ProfileAddressModel(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}

class LoyaltyProgramModel extends LoyaltyProgramDataResponse {
  LoyaltyProgramModel({
    required super.userId,
    required super.points,
    required super.tier,
  });

  factory LoyaltyProgramModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyProgramModel(
      userId: json['userId'],
      points: int.tryParse(json['points'].toString()) ?? 0,
      tier: json['tier'],
    );
  }
}

class ReferralModel extends ReferralDataResponse {
  ReferralModel({
    required super.referralCode,
    required super.rewardPoint,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      referralCode: json['referralCode'],
      rewardPoint: int.tryParse(json['rewardPoint'].toString()) ?? 0,
    );
  }
}

class ProfilePersonalInfoModel extends ProfilePersonalInfoDataResponse {
  ProfilePersonalInfoModel({
    required super.firstName,
    super.middleName,
    super.lastName,
    required super.dateOfBirth,
    required super.gender,
    super.profilePicture,
  });

  factory ProfilePersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfilePersonalInfoModel(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      profilePicture: json['profilePicture'],
    );
  }
}

class CertificationModel extends CertificationDataResponse {
  CertificationModel({
    required super.certificationId,
    required super.certificationName,
    super.validDate,
    required List<String> super.specialization,
  });

  factory CertificationModel.fromEntity(
      CertificationDataResponse certification) {
    return CertificationModel(
      certificationId: certification.certificationId,
      certificationName: certification.certificationName,
      validDate: certification.validDate,
      specialization: certification.specialization ?? [],
    );
  }

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      certificationId: json['certificationId'] as String,
      certificationName: json['certificationName'] as String,
      validDate:
          json['validDate'] != null ? DateTime.parse(json['validDate']) : null,
      specialization: json['specialization'] != null
          ? List<String>.from(json['specialization'])
          : [],
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

class DrivingLicenseModel extends DrivingLicenseDataResponse {
  DrivingLicenseModel(
      {required super.id,
      required super.licenseNumber,
      required super.frontSideImageUrl,
      required super.backSideImageUrl});

  factory DrivingLicenseModel.fromEntity(
      DrivingLicenseDataResponse drivingLicense) {
    return DrivingLicenseModel(
        id: drivingLicense.id,
        licenseNumber: drivingLicense.licenseNumber,
        frontSideImageUrl: drivingLicense.frontSideImageUrl,
        backSideImageUrl: drivingLicense.backSideImageUrl);
  }

  factory DrivingLicenseModel.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseModel(
      id: json['id'] as String,
      licenseNumber: json['licenseNumber'] as String,
      frontSideImageUrl: json['frontSideImageUrl'] as String,
      backSideImageUrl: json['backSideImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licenseNumber': licenseNumber,
      'frontSideImageUrl': frontSideImageUrl,
      'backSideImageUrl': backSideImageUrl
    };
  }
}

class NationalIdentityModel extends NationalIdentityDataResponse {
  NationalIdentityModel(
      {required super.id,
      required super.identityNumber,
      required super.frontSideImageUrl,
      required super.backSideImageUrl});

  factory NationalIdentityModel.fromEntity(
      NationalIdentityDataResponse nationalIdentity) {
    return NationalIdentityModel(
        id: nationalIdentity.id,
        identityNumber: nationalIdentity.identityNumber,
        frontSideImageUrl: nationalIdentity.frontSideImageUrl,
        backSideImageUrl: nationalIdentity.backSideImageUrl);
  }

  factory NationalIdentityModel.fromJson(Map<String, dynamic> json) {
    return NationalIdentityModel(
      id: json['id'] as String,
      identityNumber: json['identityNumber'] as String,
      frontSideImageUrl: json['frontSideImageUrl'] as String,
      backSideImageUrl: json['backSideImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identityNumber': identityNumber,
      'frontSideImageUrl': frontSideImageUrl,
      'backSideImageUrl': backSideImageUrl
    };
  }
}
