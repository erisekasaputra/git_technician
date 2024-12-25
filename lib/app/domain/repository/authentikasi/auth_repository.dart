import 'package:santai_technician/app/data/models/authentikasi/auth_forgot_password_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_reg_ver_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_req_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_res_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_request.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login_res.dart';
import '../../entities/authentikasi/auth_user_register.dart';

abstract class AuthRepository {
  Future<UserRegisterResponseModel?> registerUser(UserRegister user);
  Future<SigninUserResponseModel?> signinUser(SigninUser user);
  Future<OtpRequestResponseModel?> sendOtp(OtpRequest request);
  Future<OtpRegisterVerifyResponseModel?> otpRegisterVerify(
      OtpRegisterVerify request);
  Future<VerifyLoginResponse?> verifyLogin(VerifyLogin request);
  Future<void> signout(
      String accessToken, String refreshToken, String deviceId);
  Future<bool> resetPassword(
      String identity, String otpCode, String newPassword);
  Future<ForgotPasswordResponseModel?> forgotPassword(String phoneNumber);
}
