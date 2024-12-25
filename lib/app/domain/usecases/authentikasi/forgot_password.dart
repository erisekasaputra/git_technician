import 'package:santai_technician/app/data/models/authentikasi/auth_forgot_password_res_model.dart';
import 'package:santai_technician/app/domain/repository/authentikasi/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<ForgotPasswordResponseModel?> call(String phoneNumber) async {
    return await repository.forgotPassword(phoneNumber);
  }
}
