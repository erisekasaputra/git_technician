import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class CancelOrder {
  final OrderRepository repository;

  CancelOrder(this.repository);

  Future<bool> call(String orderId) async {
    try {
      return await repository.cancelOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
