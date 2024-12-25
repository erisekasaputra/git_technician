import '../../../domain/repository/authentikasi/auth_repository.dart';

class SignOutUser {
  final AuthRepository repository;

  SignOutUser(this.repository);

  Future<void> call(
      String accessToken, String refreshToken, String deviceId) async {
    return await repository.signout(accessToken, refreshToken, deviceId);
  }
}
