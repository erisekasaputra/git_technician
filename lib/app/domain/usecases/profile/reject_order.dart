import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class RejectOrder {
  final ProfileRepository repository;

  RejectOrder(this.repository);

  Future<bool> call(String orderId) async {
    try {
      return await repository.rejectOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
