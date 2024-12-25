import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class ActivateMechanicStatus {
  final ProfileRepository repository;

  ActivateMechanicStatus(this.repository);

  Future<bool> call() async {
    try {
      return await repository.activateMechanicStatus();
    } catch (e) {
      rethrow;
    }
  }
}
