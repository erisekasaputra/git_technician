class OtpRequest {
  final String otpProviderType;
  final String otpRequestId;
  final String otpRequestToken;

  OtpRequest({
    required this.otpProviderType,
    required this.otpRequestId,
    required this.otpRequestToken,
  });
}