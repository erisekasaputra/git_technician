import 'package:get/get.dart';
import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/datasources/profile/profile_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai_technician/app/data/repositories/profile/profile_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';
import 'package:santai_technician/app/domain/repository/profile/profile_repository.dart';
import 'package:santai_technician/app/domain/usecases/order/get_order_by_mechanic_id_and_order_id.dart';
import 'package:santai_technician/app/domain/usecases/profile/accept_order.dart';
import 'package:santai_technician/app/domain/usecases/profile/activate_mechanic_status.dart';
import 'package:santai_technician/app/domain/usecases/profile/deactivate_mechanic_status.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_mechanic_existence.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/domain/usecases/profile/reject_order.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
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

    Get.create(() => GetMechanicExistence(Get.find<ProfileRepository>()));
    Get.create(() => ActivateMechanicStatus(Get.find<ProfileRepository>()));
    Get.create(() => DeactivateMechanicStatus(Get.find<ProfileRepository>()));
    Get.create(() => AcceptOrder(Get.find<ProfileRepository>()));
    Get.create(() => RejectOrder(Get.find<ProfileRepository>()));

    Get.create(
        () => GetOrderByMechanicIdAndOrderId(Get.find<OrderRepository>()));

    Get.put<HomeController>(
      HomeController(
        getMechanicExistence: Get.find<GetMechanicExistence>(),
        activateMechanicStatus: Get.find<ActivateMechanicStatus>(),
        deactivateMechanicStatus: Get.find<DeactivateMechanicStatus>(),
        getOrderByMechanicIdAndOrderId:
            Get.find<GetOrderByMechanicIdAndOrderId>(),
        acceptOrder: Get.find<AcceptOrder>(),
        rejectOrder: Get.find<RejectOrder>(),
      ),
    );
  }
}
