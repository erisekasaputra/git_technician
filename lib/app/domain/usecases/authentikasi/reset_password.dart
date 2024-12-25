import '../../../domain/repository/authentikasi/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<bool> call(String identity, String otpCode, String password) async {
    return await repository.resetPassword(identity, otpCode, password);
  }
}
