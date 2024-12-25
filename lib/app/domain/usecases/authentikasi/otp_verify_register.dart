import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify_res.dart';

import '../../../domain/repository/authentikasi/auth_repository.dart';

class VerifyOtpRegister {
  final AuthRepository repository;

  VerifyOtpRegister(this.repository);

  Future<OtpRegisterVerifyResponse?> call(OtpRegisterVerify request) async {
    return await repository.otpRegisterVerify(request);
  }
}
