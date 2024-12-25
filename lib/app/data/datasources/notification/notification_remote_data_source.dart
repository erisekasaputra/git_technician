import 'dart:convert';

import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/notification/notification_res_model.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

abstract class NotificationRemoteDataSource {
  Future<NotifyResponseModel?> getNotificationsByLastTimestamp(
      int lastTimestamp);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  NotificationRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigNotification.baseUrl,
  });

  @override
  Future<NotifyResponseModel?> getNotificationsByLastTimestamp(
      int lastTimestamp) async {
    var response = await client.get(
      Uri.parse('$baseUrl/notifications?lastTimestamp=$lastTimestamp'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      }
      return NotifyResponseModel.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    final Map<String, dynamic> responseBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : {'message': 'Unable to get notifications'};

    throw CustomHttpException(
        response.statusCode,
        responseBody['message'] ??
            (responseBody['title'] ?? 'Unable to get notifications'));
  }
}
