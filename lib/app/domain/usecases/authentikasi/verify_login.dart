import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class LoginVerify {
  final AuthRepository repository;

  LoginVerify(this.repository);

  Future<VerifyLoginResponse?> call(VerifyLogin user) async {
    return await repository.verifyLogin(user);
  }
}
