class ForgotPasswordResponse {
  final bool isSuccess;
  final ForgotPasswordDataResponse data;
  final NextActionForgotPasswordDataResponse next;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  ForgotPasswordResponse({
    required this.isSuccess,
    required this.data,
    required this.next,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class NextActionForgotPasswordDataResponse {
  final String link;
  final String action;
  final String method;
  final String otpRequestToken;
  final String otpRequestId;
  NextActionForgotPasswordDataResponse({
    required this.link,
    required this.action,
    required this.method,
    required this.otpRequestToken,
    required this.otpRequestId,
  });
}

class ForgotPasswordDataResponse {
  final String sub;
  final String phoneNumber;
  ForgotPasswordDataResponse({
    required this.sub,
    required this.phoneNumber,
  });
}
