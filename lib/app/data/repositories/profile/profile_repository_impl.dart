import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/models/fleet/fleet_res.dart';
import 'package:santai_technician/app/data/models/profile/mechanic_existence_res_model.dart';

import 'package:santai_technician/app/data/models/profile/profile_user_req_model.dart';
import 'package:santai_technician/app/data/models/profile/profile_user_res_model.dart';
import 'package:santai_technician/app/data/models/profile/update_profile_user_req_model.dart';

import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';
import 'package:santai_technician/app/domain/entities/profile/update_profile_user_req.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileUserResponseModel?> insertProfileUser(
      ProfileUserRequest user) async {
    try {
      final profileUserModel = ProfileUserReqModel.fromEntity(user);
      final response =
          await remoteDataSource.insertProfileUser(profileUserModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileUserResponseModel?> getProfileUser(String userId) async {
    try {
      final response = await remoteDataSource.getProfileUser(userId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateProfileUser(UpdateProfileUserReq user) async {
    try {
      var userModel = UpdateProfileUserReqModel.fromEntity(user);
      final response = await remoteDataSource.updateProfileUser(userModel);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MechanicExistenceResModel?> getMechanicExistence() async {
    try {
      final response = await remoteDataSource.getMechanicExistence();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> activateMechanicStatus() async {
    try {
      final response = await remoteDataSource.activateMechanicStatus();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deactivateMechanicStatus() async {
    try {
      final response = await remoteDataSource.deactivateMechanicStatus();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> acceptOrder(String orderId) async {
    try {
      final response = await remoteDataSource.acceptOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> rejectOrder(String orderId) async {
    try {
      final response = await remoteDataSource.rejectOrder(orderId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FleetUserResponseModel?> getFleetById(
      String userId, String fleetId) async {
    try {
      final response = await remoteDataSource.getFleetById(userId, fleetId);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
