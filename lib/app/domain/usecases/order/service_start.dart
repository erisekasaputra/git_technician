import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class ServiceStart {
  final OrderRepository repository;

  ServiceStart(this.repository);
  Future<bool> call(String orderId, String fleetId, String orderSecret) async {
    try {
      return await repository.serviceStart(orderId, fleetId, orderSecret);
    } catch (e) {
      rethrow;
    }
  }
}
