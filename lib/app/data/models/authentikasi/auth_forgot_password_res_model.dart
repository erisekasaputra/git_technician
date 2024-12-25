import 'package:santai_technician/app/domain/entities/authentikasi/auth_forgot_password_res.dart';

class ForgotPasswordResponseModel extends ForgotPasswordResponse {
  ForgotPasswordResponseModel({
    required super.isSuccess,
    required ForgotPasswordDataResponseModel super.data,
    required NextActionOtpReqResModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      isSuccess: json['isSuccess'],
      data: ForgotPasswordDataResponseModel.fromJson(json['data']),
      next: NextActionOtpReqResModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class ForgotPasswordDataResponseModel extends ForgotPasswordDataResponse {
  ForgotPasswordDataResponseModel(
      {required super.sub, required super.phoneNumber});

  factory ForgotPasswordDataResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordDataResponseModel(
      sub: json['sub'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class NextActionOtpReqResModel extends NextActionForgotPasswordDataResponse {
  NextActionOtpReqResModel(
      {required super.link,
      required super.action,
      required super.method,
      required super.otpRequestToken,
      required super.otpRequestId});

  factory NextActionOtpReqResModel.fromJson(Map<String, dynamic> json) {
    return NextActionOtpReqResModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
    );
  }
}
