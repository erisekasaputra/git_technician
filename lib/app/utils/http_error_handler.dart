import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

void handleError(http.Response response, String titleDefault) {
  if (response.statusCode.isHttpResponseUnauthorized()) {
    throw CustomHttpException(response.statusCode, 'You are unauthorized');
  }

  if (response.statusCode.isHttpResponseForbidden()) {
    throw CustomHttpException(response.statusCode, 'You are forbid');
  }

  if (response.statusCode.isHttpResponseInternalServerError()) {
    throw CustomHttpException(response.statusCode, 'Internal server error',
        errorResponse: null);
  }

  if (response.statusCode.isHttpResponseNotFound()) {
    throw CustomHttpException(response.statusCode, 'Resource not found');
  }

  final responseBody =
      response.body.isNotEmpty ? jsonDecode(response.body) : null;

  if (response.statusCode.isHttpResponseBadRequest()) {
    try {
      if (responseBody == null) {
        throw CustomHttpException(
            response.statusCode, 'Validations errors has occured',
            errorResponse: null);
      }

      String? errormessage;
      if (responseBody is Map<String, dynamic>) {
        if (responseBody.containsKey('message')) {
          errormessage = responseBody['message'];
        }
      }

      ErrorResponse? error = ErrorResponse.fromJson(responseBody);
      throw CustomHttpException(response.statusCode,
          errormessage ?? error.title ?? 'We can not proceed your request',
          errorResponse: error);
    } catch (e) {
      if (e is CustomHttpException) {
        throw CustomHttpException(response.statusCode, e.message,
            errorResponse: e.errorResponse);
      }
      throw CustomHttpException(
          response.statusCode, 'Validations errors has occured',
          errorResponse: null);
    }
  }

  if (responseBody != null) {
    if (responseBody is Map<String, dynamic>) {
      if (responseBody.containsKey('message')) {
        throw CustomHttpException(response.statusCode,
            responseBody['message'] ?? 'An unexpected error occurred',
            errorResponse: null);
      }
    }
  }

  throw CustomHttpException(response.statusCode, 'An unexpected error occurred',
      errorResponse: null);
}

String parseErrorMessage(ErrorResponse error) {
  String validationErrorMessage = "";
  if (error.validationErrors?.entries != null) {
    for (var entry in error.validationErrors!.entries) {
      validationErrorMessage += '\r\n[${entry.key}]\r\n';
      for (var value in entry.value) {
        validationErrorMessage += value;
        validationErrorMessage += '\r\n';
      }
    }
  }

  if (error.errors != null) {
    for (var entry in error.errors!) {
      validationErrorMessage += '\r\n[${entry.propertyName}]\r\n';
      validationErrorMessage += entry.errorMessage;
      validationErrorMessage += '\r\n';
    }
  }

  return validationErrorMessage.isEmpty ? "" : "\r\n$validationErrorMessage";
}
