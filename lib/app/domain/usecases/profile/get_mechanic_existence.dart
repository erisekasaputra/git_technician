import 'package:santai_technician/app/data/models/profile/mechanic_existence_res_model.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class GetMechanicExistence {
  final ProfileRepository repository;

  GetMechanicExistence(this.repository);

  Future<MechanicExistenceResModel?> call() async {
    try {
      return await repository.getMechanicExistence();
    } catch (e) {
      rethrow;
    }
  }
}
