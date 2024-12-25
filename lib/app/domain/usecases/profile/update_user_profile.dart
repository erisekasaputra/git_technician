import 'package:santai_technician/app/domain/entities/profile/update_profile_user_req.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<bool> call(UpdateProfileUserReq user) async {
    try {
      return await repository.updateProfileUser(user);
    } catch (e) {
      rethrow;
    }
  }
}
