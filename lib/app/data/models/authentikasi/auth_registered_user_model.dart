import 'package:santai_technician/app/domain/entities/authentikasi/auth_registered_user.dart';

class RegisteredUserModel extends RegisteredUser {
  RegisteredUserModel({
    required super.sub,
    required super.username,
    required super.phoneNumber,
    super.email,
    required super.userType,
    super.businessCode,
    String? otp,
  });

  factory RegisteredUserModel.fromJson(Map<String, dynamic> json) {
    return RegisteredUserModel(
      sub: json['sub'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      userType: json['userType'],
      businessCode: json['businessCode'],
    );
  }
}
