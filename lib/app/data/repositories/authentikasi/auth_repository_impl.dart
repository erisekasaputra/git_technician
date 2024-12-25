import 'package:santai_technician/app/data/models/authentikasi/auth_forgot_password_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_reg_ver_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_req_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_req_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_reg_ver_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_res_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_verify_login_req_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_register_verify.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_otp_request.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_signin_user.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_user_register.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_req_model.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login.dart';
import 'package:santai_technician/app/domain/entities/authentikasi/auth_verify_login_res.dart';
import '../../../domain/repository/authentikasi/auth_repository.dart';
import '../../datasources/authentikasi/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserRegisterResponseModel?> registerUser(UserRegister user) async {
    try {
      final userModel = UserRegisterModel.fromEntity(user);
      final response = await remoteDataSource.registerUser(userModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SigninUserResponseModel?> signinUser(SigninUser user) async {
    try {
      final userModel = SigninUserModel.fromEntity(user);
      final response = await remoteDataSource.signinUser(userModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OtpRequestResponseModel?> sendOtp(OtpRequest request) async {
    try {
      final otpRequestModel = OtpRequestModel.fromEntity(request);
      final response = await remoteDataSource.sendOtp(otpRequestModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OtpRegisterVerifyResponseModel?> otpRegisterVerify(
      OtpRegisterVerify request) async {
    try {
      final otpRegisterVerifyModel = OtpRegisterVerifyModel.fromEntity(request);
      final response =
          await remoteDataSource.otpRegisterVerify(otpRegisterVerifyModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VerifyLoginResponse?> verifyLogin(VerifyLogin request) async {
    try {
      final verifyLoginModel = VerifyLoginModel.fromEntity(request);
      final response = await remoteDataSource.verifyLogin(verifyLoginModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signout(
      String accessToken, String refreshToken, String deviceId) async {
    try {
      final response =
          await remoteDataSource.signOut(accessToken, refreshToken, deviceId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordResponseModel?> forgotPassword(
      String phoneNumber) async {
    try {
      final response = await remoteDataSource.forgotPassword(phoneNumber);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(
      String identity, String otpCode, String newPassword) async {
    try {
      final response =
          await remoteDataSource.resetPassword(identity, otpCode, newPassword);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
