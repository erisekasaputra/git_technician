import 'package:get/get.dart';

import 'package:santai_technician/app/domain/usecases/authentikasi/signin_user.dart';

import 'package:santai_technician/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai_technician/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai_technician/app/data/datasources/authentikasi/auth_remote_data_source.dart';

import '../controllers/login_controller.dart';
import 'package:http/http.dart' as http;

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Register the http client
    Get.lazyPut<http.Client>(() => http.Client());

    // Register the remote data source
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    // Register the repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    // Register the use cases
    Get.lazyPut(() => UserSignIn(Get.find<AuthRepository>()));

    // Register the controller
    Get.put<LoginController>(LoginController(
      signinUser: Get.find<UserSignIn>(),
    ));
  }
}
