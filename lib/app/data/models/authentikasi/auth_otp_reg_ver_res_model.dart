import 'package:santai_technician/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

class OtpRegisterVerifyResponseModel extends OtpRegisterVerifyResponse {
  OtpRegisterVerifyResponseModel({
    required super.isSuccess,
    required RegisteredUserModel super.data,
    required NextActionOtpRegisterVerifyResponseModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory OtpRegisterVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRegisterVerifyResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionOtpRegisterVerifyResponseModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }

  factory OtpRegisterVerifyResponseModel.defaultSuccess() {
    return OtpRegisterVerifyResponseModel(
      isSuccess: true,
      data: RegisteredUserModel(
        sub: '',
        username: '',
        phoneNumber: '',
        email: '',
        userType: '',
        businessCode: '',
        otp: '',
      ),
      next: NextActionOtpRegisterVerifyResponseModel(
        link: '',
        action: 'Success',
        method: '',
      ),
      message: 'Success',
      responseStatus: 'Success',
      errors: [],
      links: [],
    );
  }
}

class NextActionOtpRegisterVerifyResponseModel
    extends NextActionOtpRegisterVerifyResponse {
  NextActionOtpRegisterVerifyResponseModel(
      {required super.link, required super.action, required super.method});

  factory NextActionOtpRegisterVerifyResponseModel.fromJson(
      Map<String, dynamic> json) {
    return NextActionOtpRegisterVerifyResponseModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
    );
  }
}
