import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/entities/order/paginated_order_res.dart';

abstract class OrderRepository {
  Future<bool> cancelOrder(String orderId);
  Future<bool> serviceStart(String orderId, String fleetId, String orderSecret);
  Future<bool> dispatchOrder(String orderId);
  Future<bool> arriveOrder(String orderId);
  Future<bool> jobChecklist(String orderId, String fleetId,
      List<Map<String, dynamic>> jobChecklists, String comment);
  Future<bool> completeOrder(
      String orderId, String orderSecret, String fleetId);
  Future<bool> incompleteOrder(
      String orderId, String orderSecret, String fleetId);
  Future<OrderResponseModel?> getOrderByMechanicIdAndOrderId(String orderId);
  Future<bool> basicInspection(
      String orderId, String fleetId, List<BasicInspection> basicInspections);
  Future<bool> preServiceInspection(String orderId, String fleetId,
      List<PreServiceInspection> preServiceInspections);
  Future<PaginatedOrderResponse?> getPaginatedOrders(
      int pageNumber, int pageSize,
      {String? orderStatus});
}
