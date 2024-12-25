import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';

class UpdateProfileUserReq {
  final String timeZoneId;
  final ProfileAddressRequest address;
  final ProfilePersonalInfoRequest personalInfo;

  UpdateProfileUserReq({
    required this.timeZoneId,
    required this.address,
    required this.personalInfo,
  });
}
