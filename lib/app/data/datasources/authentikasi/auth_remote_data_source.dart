import 'package:http/http.dart' as http;
import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_forgot_password_res_model.dart';

import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:santai_technician/app/data/models/authentikasi/auth_otp_req_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_req_res_model.dart';

import 'package:santai_technician/app/data/models/authentikasi/auth_otp_reg_ver_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_otp_reg_ver_res_model.dart';

import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_sign_in_res_model.dart';

import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_user_reg_res_model.dart';

import 'package:santai_technician/app/data/models/authentikasi/auth_verify_login_req_model.dart';
import 'package:santai_technician/app/data/models/authentikasi/auth_verify_login_res_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserRegisterResponseModel?> registerUser(UserRegisterModel user);
  Future<SigninUserResponseModel?> signinUser(SigninUserModel user);
  Future<OtpRequestResponseModel?> sendOtp(OtpRequestModel request);
  Future<OtpRegisterVerifyResponseModel?> otpRegisterVerify(
      OtpRegisterVerifyModel request);
  Future<VerifyLoginResponseModel?> verifyLogin(VerifyLoginModel request);
  Future<void> signOut(
      String accessToken, String refreshToken, String deviceId);
  Future<bool> resetPassword(
      String identity, String otpCode, String newPassword);
  Future<ForgotPasswordResponseModel?> forgotPassword(String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfig.baseUrl,
  });

  @override
  Future<void> signOut(
      String accessToken, String refreshToken, String deviceId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/signout'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "deviceId": deviceId
      }),
    );
    if (response.statusCode.isHttpResponseSuccess()) {
      return;
    }

    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'We can not log you out'};
    throw CustomHttpException(response.statusCode,
        responseBody['message'] ?? 'We can not log you out');
  }

  @override
  Future<UserRegisterResponseModel?> registerUser(
      UserRegisterModel user) async {
    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/Auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return UserRegisterResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'Could not register you account');
    return null;
  }

  @override
  Future<SigninUserResponseModel?> signinUser(SigninUserModel request) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/Auth/signin-mechanic'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return SigninUserResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(response.statusCode,
          'You are not allowed to login with this account');
    }

    handleError(response, 'We can not log you in');
    return null;
  }

  @override
  Future<OtpRequestResponseModel?> sendOtp(OtpRequestModel request) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data = json.decode(response.body);
        var responseData = OtpRequestResponseModel.fromJson(data);
        return responseData;
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'Could not send the OTP');
    return null;
  }

  @override
  Future<OtpRegisterVerifyResponseModel?> otpRegisterVerify(
      OtpRegisterVerifyModel request) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/Auth/verify-phone-number'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return OtpRegisterVerifyResponseModel.fromJson(
            json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'Could not verify you data');
    return null;
  }

  @override
  Future<VerifyLoginResponseModel?> verifyLogin(
      VerifyLoginModel request) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/Auth/verify-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data =
            VerifyLoginResponseModel.fromJson(json.decode(response.body));
        return data;
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'We can not log you in');
    return null;
  }

  @override
  Future<ForgotPasswordResponseModel?> forgotPassword(
      String phoneNumber) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          "phoneNumber": phoneNumber,
        },
      ),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return ForgotPasswordResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'Could not forgot your account');
    return null;
  }

  @override
  Future<bool> resetPassword(
      String identity, String otpCode, String newPassword) async {
    final response = await client.post(
      Uri.parse('$baseUrl/Auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "identity": identity,
        "otpCode": otpCode,
        "newPassword": newPassword
      }),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return false;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Forbidden to access this resource');
    }

    handleError(response, 'Could not reset your password');
    return false;
  }
}
