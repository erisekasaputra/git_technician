import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class CompleteOrder {
  final OrderRepository repository;

  CompleteOrder(this.repository);

  Future<bool> call(String orderId, String orderSecret, String fleetId) async {
    try {
      return await repository.completeOrder(orderId, orderSecret, fleetId);
    } catch (e) {
      rethrow;
    }
  }
}
