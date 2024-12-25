import 'package:santai_technician/app/data/models/fleet/fleet_res.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class GetFleetById {
  final ProfileRepository repository;

  GetFleetById(this.repository);

  Future<FleetUserResponseModel?> call(String userId, String fleetId) async {
    try {
      return await repository.getFleetById(userId, fleetId);
    } catch (e) {
      rethrow;
    }
  }
}
