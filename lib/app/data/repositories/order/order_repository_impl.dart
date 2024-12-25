import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/entities/order/paginated_order_res.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> cancelOrder(String orderId) async {
    try {
      final response = await remoteDataSource.cancelOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderResponseModel?> getOrderByMechanicIdAndOrderId(
      String orderId) async {
    try {
      final response =
          await remoteDataSource.getOrderByMechanicIdAndOrderId(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> arriveOrder(String orderId) async {
    try {
      final response = await remoteDataSource.arriveOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> dispatchOrder(String orderId) async {
    try {
      final response = await remoteDataSource.dispatchOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> serviceStart(
      String orderId, String fleetId, String orderSecret) async {
    try {
      final response =
          await remoteDataSource.serviceStart(orderId, fleetId, orderSecret);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> basicInspection(String orderId, String fleetId,
      List<BasicInspection> basicInspections) async {
    try {
      final response = await remoteDataSource.basicInspection(
          orderId, fleetId, basicInspections);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> completeOrder(
      String orderId, String orderSecret, String fleetId) async {
    try {
      final response =
          await remoteDataSource.completeOrder(orderId, orderSecret, fleetId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> incompleteOrder(
      String orderId, String orderSecret, String fleetId) async {
    try {
      final response =
          await remoteDataSource.incompleteOrder(orderId, orderSecret, fleetId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> jobChecklist(String orderId, String fleetId,
      List<Map<String, dynamic>> jobChecklists, String comment) async {
    try {
      final response = await remoteDataSource.jobChecklist(
          orderId, fleetId, jobChecklists, comment);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> preServiceInspection(String orderId, String fleetId,
      List<PreServiceInspection> preServiceInspections) async {
    try {
      final response = await remoteDataSource.preServiceInspection(
          orderId, fleetId, preServiceInspections);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSize,
      {String? orderStatus}) async {
    try {
      final response = await remoteDataSource
          .getPaginatedOrders(pageNumber, pageSize, orderStatus: orderStatus);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
