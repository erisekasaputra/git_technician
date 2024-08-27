
import 'package:santai_technician/app/domain/entities/user_profile_reg.dart';

abstract class UserRemoteDataSource {
  Future<void> registerUserProfile(UserProfile userProfile);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // Implement the API call to register the user profile
  @override
  Future<void> registerUserProfile(UserProfile userProfile) {
    // TODO: Implement the API call
    throw UnimplementedError();
  }
}