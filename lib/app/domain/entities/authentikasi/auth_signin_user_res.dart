import 'package:santai_technician/app/domain/entities/authentikasi/auth_registered_user.dart';

class SigninUserResponse {
  final bool isSuccess;
  final RegisteredUser? data;
  final NextActionSigninUser next;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  SigninUserResponse({
    required this.isSuccess,
    required this.data,
    required this.next,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class NextActionSigninUser {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  final List<String> otpProviderTypes;

  NextActionSigninUser({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
    required this.otpProviderTypes,
  });
}
