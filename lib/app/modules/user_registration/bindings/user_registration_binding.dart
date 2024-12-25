import 'package:get/get.dart';
import 'package:santai_technician/app/data/datasources/authentikasi/auth_remote_data_source.dart';
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/authentikasi/auth_repository_impl.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/authentikasi/auth_repository.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
// import 'package:santai_technician/app/domain/usecases/authentikasi/signout.dart';
import 'package:santai_technician/app/domain/usecases/profile/insert_profile_user.dart';
import 'package:santai_technician/app/domain/usecases/profile/update_user_profile.dart';
// import 'package:santai_technician/app/domain/usecases/profile/get_profile_user.dart';
// import 'package:santai_technician/app/domain/usecases/profile/update_profile_user.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';
import '../controllers/user_registration_controller.dart';

import 'package:http/http.dart' as http;

class UserRegistrationBinding extends Bindings {
  @override
  // void dependencies() {
  //   Get.lazyPut<UserRegistrationController>(
  //     () => UserRegistrationController(),
  //   );
  // }

  void dependencies() {
    // Register the http client
    Get.create<http.Client>(() => http.Client());
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    // Register the remote data source
    Get.create<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    // Register the repository
    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create<AuthRepository>(
      () => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>()),
    );

    // Register the use cases
    Get.create(() => UserInsertProfile(Get.find<ProfileRepository>()));
    Get.create(() => GetUserProfile(Get.find<ProfileRepository>()));
    Get.create(() => UpdateUserProfile(Get.find<ProfileRepository>()));

    Get.put<UserRegistrationController>(UserRegistrationController(
      insertProfileUser: Get.find<UserInsertProfile>(),
      getUserProfile: Get.find<GetUserProfile>(),
      updateUserProfile: Get.find<UpdateUserProfile>(),
    ));
  }
}
