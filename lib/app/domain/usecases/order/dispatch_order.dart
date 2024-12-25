import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class DispatchOrder {
  final OrderRepository repository;

  DispatchOrder(this.repository);

  Future<bool> call(String orderId) async {
    try {
      return await repository.dispatchOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
