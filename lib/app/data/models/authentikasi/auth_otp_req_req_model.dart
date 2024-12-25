import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_request.dart';

class OtpRequestModel extends OtpRequest {
  OtpRequestModel({
    required super.otpRequestId,
    required super.otpRequestToken,
    required super.otpProviderType,
  });

  factory OtpRequestModel.fromEntity(OtpRequest otpRequest) {
    return OtpRequestModel(
      otpRequestId: otpRequest.otpRequestId,
      otpRequestToken: otpRequest.otpRequestToken,
      otpProviderType: otpRequest.otpProviderType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otpRequestId': otpRequestId,
      'otpRequestToken': otpRequestToken,
      'otpProviderType': otpProviderType,
    };
  }
}
