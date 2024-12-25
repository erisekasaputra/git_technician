import 'package:santai_technician/app/data/models/profile/profile_user_res_model.dart';
import 'package:santai_technician/app/domain/entities/profile/profile_user_req.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class UserInsertProfile {
  final ProfileRepository repository;

  UserInsertProfile(this.repository);

  Future<ProfileUserResponseModel?> call(ProfileUserRequest user) async {
    try {
      return await repository.insertProfileUser(user);
    } catch (e) {
      rethrow;
    }
  }
}
