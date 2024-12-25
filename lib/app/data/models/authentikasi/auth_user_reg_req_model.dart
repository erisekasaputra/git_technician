import 'package:santai_technician/app/domain/entities/authentikasi/auth_user_register.dart';

class UserRegisterModel extends UserRegister {
  UserRegisterModel({
    required super.phoneNumber,
    required super.password,
    required super.regionCode,
    required super.userType,
  });

  factory UserRegisterModel.fromEntity(UserRegister user) {
    return UserRegisterModel(
      phoneNumber: user.phoneNumber,
      password: user.password,
      regionCode: user.regionCode,
      userType: user.userType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'regionCode': regionCode,
      'userType': userType,
    };
  }
}
