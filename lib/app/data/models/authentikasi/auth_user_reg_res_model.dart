import 'package:santai_technician/app/data/models/authentikasi/auth_registered_user_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_user_register_res.dart';

class UserRegisterResponseModel extends UserRegisterResponse {
  UserRegisterResponseModel({
    required super.isSuccess,
    required RegisteredUserModel super.data,
    required NextActionModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory UserRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponseModel(
      isSuccess: json['isSuccess'],
      data: RegisteredUserModel.fromJson(json['data']),
      next: NextActionModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class NextActionModel extends NextAction {
  NextActionModel({
    required super.link,
    required super.action,
    required super.method,
    required super.otpRequestToken,
    required super.otpRequestId,
    required super.otpProviderTypes,
  });

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(
      link: json['link'],
      action: json['action'],
      method: json['method'],
      otpRequestToken: json['otpRequestToken'],
      otpRequestId: json['otpRequestId'],
      otpProviderTypes: List<String>.from(json['otpProviderTypes']),
    );
  }
}
