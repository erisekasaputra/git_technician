import 'package:santai_technician/app/domain/entities/authentikasi/auth_registered_user.dart';

class OtpRequestResponse {
  final bool isSuccess;
  final RegisteredUser data;
  final NextActionOtpReqRes next;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  OtpRequestResponse({
    required this.isSuccess,
    required this.data,
    required this.next,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class NextActionOtpReqRes {
  final String link;
  final String action;
  final String method;

  NextActionOtpReqRes({
    required this.link,
    required this.action,
    required this.method,
  });
}