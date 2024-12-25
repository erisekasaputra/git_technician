import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/fleet/fleet_res.dart';
import 'package:santai_technician/app/data/models/profile/mechanic_existence_res_model.dart';
import 'package:santai_technician/app/data/models/profile/update_profile_user_req_model.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:santai_technician/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai_technician/app/data/models/profile/profile_user_res_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileUserResponseModel?> insertProfileUser(ProfileUserReqModel user);
  Future<ProfileUserResponseModel?> getProfileUser(String userId);
  Future<MechanicExistenceResModel?> getMechanicExistence();
  Future<bool> activateMechanicStatus();
  Future<bool> deactivateMechanicStatus();
  Future<bool> acceptOrder(String orderId);
  Future<bool> rejectOrder(String orderId);
  Future<FleetUserResponseModel?> getFleetById(String userId, String fleetId);
  Future<bool> updateProfileUser(UpdateProfileUserReqModel user);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigAccount.baseUrl,
  });

  @override
  Future<ProfileUserResponseModel?> insertProfileUser(
      ProfileUserReqModel user) async {
    const uuid = Uuid();
    final idempotencyKey = uuid.v4();

    final response = await client.post(
      Uri.parse('$baseUrl/users/mechanic'),
      headers: {
        'Content-Type': 'application/json',
        'X-Idempotency-Key': idempotencyKey,
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return ProfileUserResponseModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to create account. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> updateProfileUser(UpdateProfileUserReqModel user) async {
    final response = await client.put(
      Uri.parse('$baseUrl/users/mechanic'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to create account. Please try again shortly');
    throw Exception();
  }

  @override
  Future<ProfileUserResponseModel?> getProfileUser(String userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/mechanic/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data = json.decode(response.body);
        var result = ProfileUserResponseModel.fromJson(data);
        return result;
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to fetch user profile. Please try again shortly');
    throw Exception();
  }

  @override
  Future<FleetUserResponseModel?> getFleetById(
      String userId, String fleetId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/$userId/fleet/$fleetId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data = json.decode(response.body);
        var result = FleetUserResponseModel.fromJson(data);
        return result;
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(
        response, 'Unable to fetch user fleet. Please try again shortly');
    throw Exception();
  }

  @override
  Future<MechanicExistenceResModel?> getMechanicExistence() async {
    final response = await client.get(
      Uri.parse('$baseUrl/users/mechanic/status'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        throw CustomHttpException(500, "Internal server error");
      } else {
        return MechanicExistenceResModel.fromJson(json.decode(response.body));
      }
    }

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseForbidden()) {
      throw CustomHttpException(
          response.statusCode, 'Your access is forbidden');
    }

    handleError(response, 'Unable to fetch mechanic status');
    throw Exception();
  }

  @override
  Future<bool> activateMechanicStatus() async {
    final response = await client.patch(
      Uri.parse('$baseUrl/users/mechanic/status/activate'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(
        response, 'Unable to active your account. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> deactivateMechanicStatus() async {
    final response = await client.patch(
      Uri.parse('$baseUrl/users/mechanic/status/deactivate'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(
        response, 'Unable to disable your account. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> acceptOrder(String orderId) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/users/mechanic/order/$orderId/accept'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to accept the order.');
    throw Exception();
  }

  @override
  Future<bool> rejectOrder(String orderId) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/users/mechanic/order/$orderId/reject'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to reject the order.');
    throw Exception();
  }
}
