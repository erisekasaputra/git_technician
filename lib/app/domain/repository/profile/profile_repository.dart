import 'package:santai_technician/app/data/models/fleet/fleet_res.dart';
import 'package:santai_technician/app/data/models/profile/mechanic_existence_res_model.dart';
import 'package:santai_technician/app/data/models/profile/profile_user_res_model.dart';
import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';
import 'package:santai_technician/app/domain/entities/profile/update_profile_user_req.dart';

abstract class ProfileRepository {
  Future<ProfileUserResponseModel?> insertProfileUser(ProfileUserRequest user);
  Future<ProfileUserResponseModel?> getProfileUser(String userId);
  Future<bool> updateProfileUser(UpdateProfileUserReq user);
  Future<MechanicExistenceResModel?> getMechanicExistence();
  Future<FleetUserResponseModel?> getFleetById(String userId, String fleetId);
  Future<bool> activateMechanicStatus();
  Future<bool> deactivateMechanicStatus();
  Future<bool> acceptOrder(String orderId);
  Future<bool> rejectOrder(String orderId);
}
