class VerifyLoginResponse {
  final bool isSuccess;
  final Data data;
  final NextAction next;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  VerifyLoginResponse({
    required this.isSuccess,
    required this.data,
    required this.next,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class Data {
  final String accessToken;
  final RefreshToken refreshToken;
  final String sub;
  final String username;
  final String phoneNumber;
  final String? email;
  final String userType;
  final String? businessCode;

  Data({
    required this.accessToken,
    required this.refreshToken,
    required this.sub,
    required this.username,
    required this.phoneNumber,
    this.email,
    required this.userType,
    this.businessCode
  });
}

class RefreshToken {
  final String token;
  final String expiryDateUtc;
  final String userId;

  RefreshToken({
    required this.token,
    required this.expiryDateUtc,
    required this.userId,
  });
}

class NextAction {
  final String action;

  NextAction({
    required this.action
  });
}