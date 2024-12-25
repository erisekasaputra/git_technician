import 'package:santai_technician/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai_technician/app/domain/entities/profile/update_profile_user_req.dart';

class UpdateProfileUserReqModel extends UpdateProfileUserReq {
  UpdateProfileUserReqModel({
    required super.timeZoneId,
    required ProfileAddressReqModel super.address,
    required ProfilePersonalInfoReqModel super.personalInfo,
  });

  factory UpdateProfileUserReqModel.fromEntity(
      UpdateProfileUserReq profileUser) {
    return UpdateProfileUserReqModel(
      timeZoneId: profileUser.timeZoneId,
      address: ProfileAddressReqModel.fromEntity(profileUser.address),
      personalInfo:
          ProfilePersonalInfoReqModel.fromEntity(profileUser.personalInfo),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeZoneId': timeZoneId,
      'address': (address as ProfileAddressReqModel).toJson(),
      'personalInfo': (personalInfo as ProfilePersonalInfoReqModel).toJson(),
    };
  }
}
