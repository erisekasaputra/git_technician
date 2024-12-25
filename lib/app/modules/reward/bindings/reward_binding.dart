import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

import '../controllers/reward_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => GetUserProfile(Get.find<ProfileRepository>()));

    Get.put<RewardController>(
      RewardController(getUserProfile: Get.find<GetUserProfile>()),
    );
  }
}
