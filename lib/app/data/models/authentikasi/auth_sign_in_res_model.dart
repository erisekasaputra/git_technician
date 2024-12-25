import 'package:santai_technician/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user_res.dart';

class SigninUserResponseModel extends SigninUserResponse {
  SigninUserResponseModel({
    required super.isSuccess,
    required RegisteredUserModel? super.data,
    required NextActionSigninUserModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory SigninUserResponseModel.fromJson(Map<String, dynamic> json) {
    return SigninUserResponseModel(
      isSuccess: json['isSuccess'],
      data: json['data'] == null
          ? null
          : RegisteredUserModel.fromJson(json['data']),
      next: NextActionSigninUserModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class NextActionSigninUserModel extends NextActionSigninUser {
  NextActionSigninUserModel({
    required super.link,
    required super.action,
    required super.method,
    required super.otpRequestToken,
    required super.otpRequestId,
    required super.otpProviderTypes,
  });

  factory NextActionSigninUserModel.fromJson(Map<String, dynamic> json) {
    return NextActionSigninUserModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}
