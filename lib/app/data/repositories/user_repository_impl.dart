import 'package:santai_technician/app/data/repositories/user_repository.dart';
import 'package:santai_technician/app/domain/entities/user.dart';
import 'package:santai_technician/app/domain/entities/user_profile_reg.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> login(String phone, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    return User(phone: phone, password: password); // Return user data
  }

  Future<void> registerUserProfile(UserProfile userProfile) async {
  // Simulate API call
  await Future.delayed(Duration(seconds: 2));
  // Here you would typically send the userProfile data to your backend
  print('Registering user: ${userProfile.fullName}');
}


}