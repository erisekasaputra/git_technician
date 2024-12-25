import 'package:santai_technician/app/domain/entities/profile/profile_user_res.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<ProfileUserResponse?> call(String userId) async {
    try {
      return await repository.getProfileUser(userId);
    } catch (e) {
      rethrow;
    }
  }
}
