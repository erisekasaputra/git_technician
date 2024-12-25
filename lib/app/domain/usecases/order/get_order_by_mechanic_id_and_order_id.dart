import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class GetOrderByMechanicIdAndOrderId {
  final OrderRepository repository;

  GetOrderByMechanicIdAndOrderId(this.repository);

  Future<OrderResponseModel?> call(String orderId) async {
    try {
      return await repository.getOrderByMechanicIdAndOrderId(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
