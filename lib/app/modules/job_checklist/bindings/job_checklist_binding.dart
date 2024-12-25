import 'package:get/get.dart';
import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';
import 'package:santai_technician/app/domain/usecases/order/complete_order.dart';
import 'package:santai_technician/app/domain/usecases/order/incomplete_order.dart';
import 'package:santai_technician/app/domain/usecases/order/job_checklist.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

import '../controllers/job_checklist_controller.dart';
import 'package:http/http.dart' as http;

class JobChecklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<SecureStorageService>(() => SecureStorageService());
    Get.create<http.Client>(() => http.Client());
    Get.create<AuthHttpClient>(() => AuthHttpClient(
        Get.find<http.Client>(), Get.find<SecureStorageService>()));

    Get.create<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(client: Get.find<AuthHttpClient>()),
    );
    Get.create<OrderRepository>(
      () => OrderRepositoryImpl(
          remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );

    Get.create(() => CompleteOrder(Get.find<OrderRepository>()));
    Get.create(() => IncompleteOrder(Get.find<OrderRepository>()));
    Get.create(() => JobChecklist(Get.find<OrderRepository>()));

    Get.put<JobChecklistController>(
      JobChecklistController(
          completeOrder: Get.find<CompleteOrder>(),
          incompleteOrder: Get.find<IncompleteOrder>(),
          jobChecklist: Get.find<JobChecklist>()),
    );
  }
}
