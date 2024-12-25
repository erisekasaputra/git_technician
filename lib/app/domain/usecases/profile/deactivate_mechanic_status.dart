import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class DeactivateMechanicStatus {
  final ProfileRepository repository;

  DeactivateMechanicStatus(this.repository);

  Future<bool> call() async {
    try {
      return await repository.deactivateMechanicStatus();
    } catch (e) {
      rethrow;
    }
  }
}
