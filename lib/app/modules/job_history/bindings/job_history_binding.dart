import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';
import 'package:santai_technician/app/domain/usecases/order/get_paginated_orders.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

import '../controllers/job_history_controller.dart';

class JobHistoryBinding extends Bindings {
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

    Get.create(() => GetPaginatedOrders(Get.find<OrderRepository>()));

    Get.put<JobHistoryController>(
      JobHistoryController(getPaginatedOrders: Get.find<GetPaginatedOrders>()),
    );
  }
}
