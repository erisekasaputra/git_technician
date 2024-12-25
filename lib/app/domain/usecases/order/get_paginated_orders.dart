import 'package:santai_technician/app/domain/entities/order/paginated_order_res.dart';
import 'package:santai_technician/app/domain/repository/order/order_repository.dart';

class GetPaginatedOrders {
  final OrderRepository repository;

  GetPaginatedOrders(this.repository);
  Future<PaginatedOrderResponse?> call(int pageNumber, int pageSize,
      {String? orderStatus}) async {
    try {
      return await repository.getPaginatedOrders(pageNumber, pageSize,
          orderStatus: orderStatus);
    } catch (e) {
      rethrow;
    }
  }
}
