import '../data/models/common/base_error.dart';

class CustomHttpException implements Exception {
  final int statusCode;
  final String message;
  final ErrorResponse? errorResponse;

  CustomHttpException(this.statusCode, this.message, {this.errorResponse});

  @override
  String toString() => 'CustomHttpException: [$statusCode] $message';
}
