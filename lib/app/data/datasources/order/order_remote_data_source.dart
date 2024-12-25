import 'dart:convert';
import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/data/models/order/paginated_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/entities/order/paginated_order_res.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/int_extension_method.dart';

abstract class OrderRemoteDataSource {
  Future<bool> cancelOrder(String orderId);
  Future<OrderResponseModel?> getOrderByMechanicIdAndOrderId(String orderId);
  Future<bool> dispatchOrder(String orderId);
  Future<bool> arriveOrder(String orderId);
  Future<bool> completeOrder(
      String orderId, String orderSecret, String fleetId);
  Future<bool> incompleteOrder(
      String orderId, String orderSecret, String fleetId);
  Future<bool> serviceStart(String orderId, String fleetId, String orderSecret);
  Future<bool> basicInspection(
      String orderId, String fleetId, List<BasicInspection> basicInspections);
  Future<bool> preServiceInspection(String orderId, String fleetId,
      List<PreServiceInspection> preServiceInspections);
  Future<bool> jobChecklist(String orderId, String fleetId,
      List<Map<String, dynamic>> jobChecklists, String comment);
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSize,
      {String? orderStatus});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final AuthHttpClient client;
  final String baseUrl;

  OrderRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = ApiConfigOrder.baseUrl,
  });

  @override
  Future<bool> cancelOrder(String orderId) async {
    final response = await client.patch(
      Uri.parse('${ApiConfigOrder.baseUrl}/orders/$orderId/mechanic/cancel'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to cancel the order');
    throw Exception();
  }

  @override
  Future<bool> dispatchOrder(String orderId) async {
    final response = await client.patch(
      Uri.parse('${ApiConfigOrder.baseUrl}/orders/$orderId/mechanic/dispatch'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to set the order status to dispatch');
    throw Exception();
  }

  @override
  Future<bool> arriveOrder(String orderId) async {
    final response = await client.patch(
      Uri.parse('${ApiConfigOrder.baseUrl}/orders/$orderId/mechanic/arrive'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to set the order status to arrive');
    throw Exception();
  }

  @override
  Future<bool> serviceStart(
      String orderId, String fleetId, String orderSecret) async {
    final response = await client.patch(
        Uri.parse(
            '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/start'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'secret': orderSecret}));

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to start servicing the order');
    throw Exception();
  }

  @override
  Future<bool> basicInspection(String orderId, String fleetId,
      List<BasicInspection> basicInspections) async {
    final response = await client.patch(
      Uri.parse(
          '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/basic-inspection'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'basicInspections': basicInspections
            .map((elemen) => BasicInspectionModel.toJson(elemen))
            .toList(),
      }),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to process basic inspection');
    throw Exception();
  }

  @override
  Future<OrderResponseModel?> getOrderByMechanicIdAndOrderId(
      String orderId) async {
    var response = await client.get(
        Uri.parse('$baseUrl/orders/$orderId/mechanic'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      }
      return OrderResponseModel.fromJson(jsonDecode(response.body));
    }

    handleError(response, 'Unable to get order data. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> completeOrder(
      String orderId, String orderSecret, String fleetId) async {
    final response = await client.patch(
        Uri.parse(
            '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/success'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'secret': orderSecret}));

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(
        response, 'Unable to complete the order. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> incompleteOrder(
      String orderId, String orderSecret, String fleetId) async {
    final response = await client.patch(
        Uri.parse(
            '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/failed'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'secret': orderSecret}));

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response, 'Unable to incomplete the order');
    throw Exception();
  }

  @override
  Future<bool> jobChecklist(String orderId, String fleetId,
      List<Map<String, dynamic>> jobChecklists, comment) async {
    final response = await client.patch(
        Uri.parse(
            '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/job-checklist'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jobChecklists': jobChecklists,
          'comment': comment,
        }));

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(
        response, 'Unable to checklist the job. Please try again shortly');
    throw Exception();
  }

  @override
  Future<bool> preServiceInspection(String orderId, String fleetId,
      List<PreServiceInspection> preServiceInspections) async {
    final response = await client.patch(
      Uri.parse(
          '${ApiConfigOrder.baseUrl}/orders/$orderId/service/fleet/$fleetId/pre-service-inspection'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'preServiceInspections': preServiceInspections
            .map((elemen) => PreServiceInspectionModel.toJson(elemen))
            .toList(),
      }),
    );

    if (response.statusCode.isHttpResponseSuccess()) {
      return true;
    }

    handleError(response,
        'Unable to service inspection the order. Please try again shortly');
    throw Exception();
  }

  @override
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSize,
      {String? orderStatus}) async {
    var response = await client.get(
        Uri.parse(
            '$baseUrl/orders/mechanic?pageNumber=$pageNumber&pageSize=$pageSize${orderStatus == null ? '' : '&orderStatus=$orderStatus'}'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode.isHttpResponseNotFound()) {
      return null;
    }

    if (response.statusCode.isHttpResponseSuccess()) {
      if (response.body.isEmpty) {
        return null;
      }

      var responseBody = jsonDecode(response.body);
      var data = PaginatedOrderResponseModel.fromJson(responseBody);
      return data;
    }

    handleError(response,
        'Unable to fetch the orders history. Please try again shortly');
    throw Exception();
  }
}
