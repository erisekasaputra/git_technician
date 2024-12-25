import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/paginated_order_res.dart';

class PaginatedOrderResponseModel extends PaginatedOrderResponse {
  PaginatedOrderResponseModel({
    required super.isSuccess,
    required PaginatedOrderResponseDataModel super.data,
    required super.message,
    required super.responseStatus,
    required List<String>
        super.errors, // Change to List<String> if you expect string errors
    required super.links,
  });

  factory PaginatedOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOrderResponseModel(
      isSuccess: json['isSuccess'],
      data: PaginatedOrderResponseDataModel.fromJson(json['data']),
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors:
          List<String>.from(json['errors']), // Parsing errors to List<String>
      links: json['links'] ??
          [], // Ensure `links` is a List<dynamic>, or empty list if null
    );
  }
}

class PaginatedOrderResponseDataModel extends PaginatedOrderResponseData {
  PaginatedOrderResponseDataModel({
    required super.pageNumber,
    required super.pageSize,
    required super.pageCount,
    required super.totalPages,
    required List<OrderResponseDataModel> super.items,
  });

  factory PaginatedOrderResponseDataModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOrderResponseDataModel(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      totalPages: json['totalPages'],
      items: List<OrderResponseDataModel>.from(
          json['items'].map((item) => OrderResponseDataModel.fromJson(item))),
    );
  }
}
