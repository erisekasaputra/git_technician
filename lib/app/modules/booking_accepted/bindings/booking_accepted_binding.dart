import 'package:get/get.dart';
import 'package:santai_technician/app/data/datasources/order/order_remote_data_source.dart';
import 'package:santai_technician/app/data/repositories/order/order_repository_impl.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';
import 'package:santai_technician/app/domain/usecases/order/arrive_order.dart';
import 'package:santai_technician/app/domain/usecases/order/cancel_order.dart';
import 'package:santai_technician/app/domain/usecases/order/dispatch_order.dart';
import 'package:santai_technician/app/services/auth_http_client.dart';
import 'package:santai_technician/app/services/secure_storage_service.dart';

import '../controllers/booking_accepted_controller.dart';
import 'package:http/http.dart' as http;

class BookingAcceptedBinding extends Bindings {
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

    Get.create(() => CancelOrder(Get.find<OrderRepository>()));
    Get.create(() => ArriveOrder(Get.find<OrderRepository>()));
    Get.create(() => DispatchOrder(Get.find<OrderRepository>()));

    Get.put<BookingAcceptedController>(
      BookingAcceptedController(
          cancelOrderUseCase: Get.find<CancelOrder>(),
          arriveOrder: Get.find<ArriveOrder>(),
          dispatchOrder: Get.find<DispatchOrder>()),
    );
  }
}
