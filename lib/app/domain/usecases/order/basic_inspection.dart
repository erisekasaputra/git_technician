import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class BasicInspectionUseCase {
  final OrderRepository repository;

  BasicInspectionUseCase(this.repository);
  Future<bool> call(String orderId, String fleetId,
      List<BasicInspection> basicInspections) async {
    try {
      return await repository.basicInspection(
          orderId, fleetId, basicInspections);
    } catch (e) {
      rethrow;
    }
  }
}
