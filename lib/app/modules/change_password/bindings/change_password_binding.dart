import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai_technician/app/domain/usecases/authentikasi/reset_password.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<http.Client>(() => http.Client());

    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    Get.create(() => ResetPassword(Get.find<AuthRepository>()));
    Get.put<ChangePasswordController>(
      ChangePasswordController(
        resetPassword: Get.find<ResetPassword>(),
      ),
    );
  }
}
