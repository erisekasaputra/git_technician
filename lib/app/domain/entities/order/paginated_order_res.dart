import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';

class PaginatedOrderResponse {
  final bool isSuccess;
  final PaginatedOrderResponseData data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;
  final dynamic next;

  PaginatedOrderResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
    this.next,
  });
}

class PaginatedOrderResponseData {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final int totalPages;
  final List<OrderResponseData> items;

  PaginatedOrderResponseData({
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.totalPages,
    required this.items,
  });
}
