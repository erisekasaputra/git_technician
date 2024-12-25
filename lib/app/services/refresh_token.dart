import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

Future<(int statusCode, String? accessToken, String? refreshToken)>
    requestRefreshToken({
  required String accessToken,
  required String refreshToken,
  required String deviceId,
  required http.Client client,
}) async {
  try {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/Auth/refresh-token'),
      body: json.encode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'deviceId': deviceId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      final data = json.decode(response.body)['data'] as Map<String, dynamic>?;

      if (data != null &&
          data['token'] != null &&
          data['refreshToken'] != null) {
        // Mengembalikan status sukses dan token yang baru
        return (200, data['token'] as String, data['refreshToken'] as String);
      }
    }
  } catch (e) {
    if (e is CustomHttpException) {
      return (e.statusCode, null, null);
    }
    return (500, null, null);
  }
  return (400, null, null);
}
