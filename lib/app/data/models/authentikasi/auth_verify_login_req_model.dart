import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login.dart';

class VerifyLoginModel extends VerifyLogin {
  VerifyLoginModel({
    required super.deviceId,
    required super.phoneNumber,
    required super.token,
  });

  factory VerifyLoginModel.fromEntity(VerifyLogin user) {
    return VerifyLoginModel(
      phoneNumber: user.phoneNumber,
      token: user.token,
      deviceId: user.deviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'token': token,
      'deviceId': deviceId,
    };
  }
}
