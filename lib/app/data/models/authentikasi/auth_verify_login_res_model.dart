import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login_res.dart';

class VerifyLoginResponseModel extends VerifyLoginResponse {
  VerifyLoginResponseModel({
    required super.isSuccess,
    required super.data,
    required NextActionModel super.next,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  });

  factory VerifyLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginResponseModel(
      isSuccess: json['isSuccess'],
      data: DataModel.fromJson(json['data']),
      next: NextActionModel.fromJson(json['next']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
    );
  }
}

class DataModel extends Data {
  DataModel({
    required super.accessToken,
    required RefreshTokenModel super.refreshToken,
    required super.sub,
    required super.username,
    required super.phoneNumber,
    required super.email,
    required super.userType,
    required super.businessCode,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      accessToken: json['accessToken'],
      refreshToken: RefreshTokenModel.fromJson(json['refreshToken']),
      sub: json['sub'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userType: json['userType'],
      businessCode: json['businessCode'],
    );
  }
}

class RefreshTokenModel extends RefreshToken {
  RefreshTokenModel({
    required super.token,
    required super.expiryDateUtc,
    required super.userId,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      token: json['token'],
      expiryDateUtc: json['expiryDateUtc'],
      userId: json['userId'],
    );
  }
}

class NextActionModel extends NextAction {
  NextActionModel({
    required super.action,
  });

  factory NextActionModel.fromJson(Map<String, dynamic> json) {
    return NextActionModel(action: json['action']);
  }
}
