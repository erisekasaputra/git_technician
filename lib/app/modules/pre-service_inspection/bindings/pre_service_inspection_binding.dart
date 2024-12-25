import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/order/basic_inspection.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_fleet_by_id.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';
import '../controllers/pre_service_inspection_controller.dart';

class PreServiceInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );

    Get.create<ProfileRepository>(
      () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>()),
    );
    Get.create<OrderRepository>(
      () => OrderRepositoryImpl(
          remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );

    Get.create(() => GetFleetById(Get.find<ProfileRepository>()));
    Get.create(() => BasicInspectionUseCase(Get.find<OrderRepository>()));

    Get.put<PreServiceInspectionController>(
      PreServiceInspectionController(
          getFleetById: Get.find<GetFleetById>(),
          basicInspectionUseCase: Get.find<BasicInspectionUseCase>()),
    );
  }
}
