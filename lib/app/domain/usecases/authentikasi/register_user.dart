import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_res_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_user_register.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserRegisterResponseModel?> call(UserRegister user) async {
    try {
      return await repository.registerUser(user);
    } catch (e) {
      rethrow;
    }
  }
}
