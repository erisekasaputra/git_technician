import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify.dart';

class OtpRegisterVerifyModel extends OtpRegisterVerify {
    OtpRegisterVerifyModel({
    required super.phoneNumber,
    required super.token,
  });

  factory OtpRegisterVerifyModel.fromEntity(OtpRegisterVerify otpRequest) {
    return OtpRegisterVerifyModel(
      phoneNumber: otpRequest.phoneNumber,
      token: otpRequest.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'token': token,
    };
  }
}