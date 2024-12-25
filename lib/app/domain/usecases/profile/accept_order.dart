import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class AcceptOrder {
  final ProfileRepository repository;

  AcceptOrder(this.repository);

  Future<bool> call(String orderId) async {
    try {
      return await repository.acceptOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }
}
