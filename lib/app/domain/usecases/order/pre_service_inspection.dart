import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class PreServiceInspectionUseCase {
  final OrderRepository repository;

  PreServiceInspectionUseCase(this.repository);
  Future<bool> call(String orderId, String fleetId,
      List<PreServiceInspection> preServiceInspections) async {
    try {
      return await repository.preServiceInspection(
          orderId, fleetId, preServiceInspections);
    } catch (e) {
      rethrow;
    }
  }
}
