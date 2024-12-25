import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class ArriveOrder {
  final OrderRepository repository;

  ArriveOrder(this.repository);

  Future<bool> call(String orderId) async {
    try {
      return await repository.arriveOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
