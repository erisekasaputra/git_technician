import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class JobChecklist {
  final OrderRepository repository;

  JobChecklist(this.repository);

  Future<bool> call(String orderId, String fleetId,
      List<Map<String, dynamic>> jobChecklists, String comment) async {
    try {
      return await repository.jobChecklist(
          orderId, fleetId, jobChecklists, comment);
    } catch (e) {
      rethrow;
    }
  }
}
