class ResponseCodeModel {
  final String code;
  final String message;

  ResponseCodeModel({
    required this.code,
    required this.message,
  });

  factory ResponseCodeModel.fromJson(Map<String, dynamic> json) {
    return ResponseCodeModel(
      code: json['code'] ?? 'unknown',
      message: json['message'] ?? 'No message provided',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}