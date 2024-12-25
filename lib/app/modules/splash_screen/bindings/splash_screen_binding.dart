import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/common/common_remote_data_source.dart';
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/common/common_repository_impl.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/common/common_repository.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/common/common_get_img_url_public.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_user_profile.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );
    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<CommonRepository>(
      () => CommonRepositoryImpl(
          remoteDataSource: Get.find<CommonRemoteDataSource>()),
    );
    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );

    Get.create(() => CommonGetImgUrlPublic(Get.find<CommonRepository>()));
    Get.create(() => GetUserProfile(Get.find<ProfileRepository>()));

    Get.put(SplashScreenController(
        commonGetImgUrlPublic: Get.find<CommonGetImgUrlPublic>(),
        getUserProfile: Get.find<GetUserProfile>()));
  }
}
