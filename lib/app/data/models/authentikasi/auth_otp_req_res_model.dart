import 'package:santai_technician/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_request_res.dart';

class OtpRequestResponseModel extends OtpRequestResponse {
  OtpRequestResponseModel({
    required super.isSuccess,
    required RegisteredUserModel super.data,
    required NextActionOtpReqResModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory OtpRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionOtpReqResModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class NextActionOtpReqResModel extends NextActionOtpReqRes {
  NextActionOtpReqResModel(
      {required super.link, required super.action, required super.method});

  factory NextActionOtpReqResModel.fromJson(Map<String, dynamic> json) {
    return NextActionOtpReqResModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
    );
  }
}
