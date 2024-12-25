import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class IncompleteOrder {
  final OrderRepository repository;

  IncompleteOrder(this.repository);

  Future<bool> call(String orderId, String orderSecret, String fleetId) async {
    try {
      return await repository.incompleteOrder(orderId, orderSecret, fleetId);
    } catch (e) {
      rethrow;
    }
  }
}
