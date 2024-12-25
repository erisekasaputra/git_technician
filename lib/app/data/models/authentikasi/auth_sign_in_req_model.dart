import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user.dart';

class SigninUserModel extends SigninUser {
  SigninUserModel(
      {required super.phoneNumber,
      required super.password,
      required super.regionCode});

  factory SigninUserModel.fromEntity(SigninUser user) {
    return SigninUserModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
    };
  }
}
