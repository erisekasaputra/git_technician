class ErrorResponse {
  final String? type;
  final String? title;
  final int? status;
  final Map<String, List<String>>? validationErrors; // For first format
  final List<ErrorDetail>? errors; // For second format
  final String? traceId;

  ErrorResponse({
    this.type,
    this.title,
    this.status,
    this.validationErrors,
    this.errors,
    this.traceId,
  });

  /// Factory to parse the error response flexibly
  factory ErrorResponse.fromJson(dynamic json) {
    // Case 1: If json is a Map
    if (json is Map<String, dynamic>) {
      if (json.containsKey('errors')) {
        final errors = json['errors'];
        if (errors is Map<String, dynamic>) {
          // First format: Validation errors
          return ErrorResponse(
            type: json['type'],
            title: json['title'],
            status: json['status'],
            validationErrors: errors.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ),
            traceId: json['traceId'],
          );
        } else if (errors is List) {
          // Second format: Detailed errors
          return ErrorResponse(
            type: json['type'],
            title: json['title'],
            status: json['status'],
            errors: errors
                .map((e) => ErrorDetail.fromJson(Map<String, dynamic>.from(e)))
                .toList(),
            traceId: json['traceId'],
          );
        }
      }

      // Default format
      return ErrorResponse(
        type: json['type'],
        title: json['title'],
        status: json['status'],
        traceId: json['traceId'],
      );
    }

    // Case 2: If json is a List (e.g., your provided response format)
    if (json is List) {
      return ErrorResponse(
        errors: json
            .map((e) => ErrorDetail.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }

    // Default fallback for unexpected cases
    throw const FormatException("Unsupported JSON format for ErrorResponse");
  }

  /// Convert ErrorResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'status': status,
      'errors': validationErrors ?? errors?.map((e) => e.toJson()).toList(),
      'traceId': traceId,
    };
  }
}

class ErrorDetail {
  final String propertyName;
  final String errorMessage;
  final dynamic attemptedValue; // Updated to dynamic to handle various types
  final String? errorCode;
  final String? severity;

  ErrorDetail({
    required this.propertyName,
    required this.errorMessage,
    this.attemptedValue,
    this.errorCode,
    this.severity,
  });

  /// Factory to parse ErrorDetail from JSON
  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      propertyName: json['propertyName'],
      errorMessage: json['errorMessage'],
      attemptedValue: json['attemptedValue'],
      errorCode: json['errorCode'],
      severity: json['severity'],
    );
  }

  /// Convert ErrorDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyName': propertyName,
      'errorMessage': errorMessage,
      'attemptedValue': attemptedValue,
      'errorCode': errorCode,
      'severity': severity,
    };
  }
}
