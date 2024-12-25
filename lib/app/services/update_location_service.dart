import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/services/location_service.dart';
import 'package:santai_technician/app/services/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/utils/int_extension_method.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class UpdateLocationService extends GetxService {
  final SessionManager sessionManager = SessionManager();
  Future<void> startService() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      LocationService locationService = LocationService();

      var (isSuccess, errorMessage, position) =
          await locationService.determinePosition();

      if (position != null) {
        await updateLocationToServer(position.latitude, position.longitude);
      }
    });
  }

  Future<void> updateLocationToServer(double latitude, double longitude) async {
    try {
      var accessToken =
          await sessionManager.getSessionBy(SessionManagerType.accessToken);
      var refreshToken =
          await sessionManager.getSessionBy(SessionManagerType.refreshToken);
      var deviceId =
          await sessionManager.getSessionBy(SessionManagerType.deviceId);

      if (accessToken.isEmpty || refreshToken.isEmpty || deviceId.isEmpty) {
        return;
      }

      final response = await http.patch(
        Uri.parse(
            '${ApiConfigAccount.baseUrl}/users/mechanic/location?latitude=$latitude&longitude=$longitude'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );

      if (response.statusCode.isHttpResponseUnauthorized()) {
        var (statusCode, newAccessToken, newRefreshToken) =
            await requestRefreshToken(
                accessToken: accessToken,
                refreshToken: refreshToken,
                deviceId: deviceId,
                client: http.Client());
        if (statusCode.isHttpResponseSuccess() &&
            newAccessToken != null &&
            newRefreshToken != null) {
          await sessionManager.setSessionBy(
              SessionManagerType.accessToken, newAccessToken);
          await sessionManager.setSessionBy(
              SessionManagerType.refreshToken, newRefreshToken);

          final response2 = await http.patch(
            Uri.parse(
                '${ApiConfigAccount.baseUrl}/users/mechanic/location?latitude=$latitude&longitude=$longitude'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
          );

          if (!response2.statusCode.isHttpResponseSuccess()) {
            throw Error();
          }
        }
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }
}
