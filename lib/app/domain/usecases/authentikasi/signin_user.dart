import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_res_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class UserSignIn {
  final AuthRepository repository;

  UserSignIn(this.repository);

  Future<SigninUserResponseModel?> call(SigninUser user) async {
    try {
      return await repository.signinUser(user);
    } catch (e) {
      rethrow;
    }
  }
}
