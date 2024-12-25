import 'package:santai_technician/app/domain/entities/profile/mechanic_existence_res.dart';

class MechanicExistenceResModel extends MechanicExistenceResponse {
  MechanicExistenceResModel({
    required super.isSuccess,
    required MechanicExistenceDataModel? data, // Nullable data parameter
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
  }) : super(data: data);

  factory MechanicExistenceResModel.fromJson(Map<String, dynamic> json) {
    return MechanicExistenceResModel(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] != null
          ? MechanicExistenceDataModel.fromJson(json['data'])
          : null, // Set data to null if json['data'] is null
      message: json['message'] as String,
      responseStatus: json['responseStatus'] as String,
      errors: json['errors'] ?? [], // Default to empty list if null
      links: json['links'] ?? [], // Default to empty list if null
    );
  }
}

class MechanicExistenceDataModel extends MechanicExistenceDataResponse {
  MechanicExistenceDataModel(
      {required super.mechanicId,
      required super.latitude,
      required super.longitude,
      required super.orderId,
      required super.status,
      required super.remainingTime,
      super.orderTask});

  factory MechanicExistenceDataModel.fromJson(Map<String, dynamic> json) {
    return MechanicExistenceDataModel(
        mechanicId: json['mechanicId'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        orderId: json['orderId'] as String,
        status: json['status'] as String,
        remainingTime: json['remainingTime'] as int,
        orderTask: json['orderTask'] == null || json['orderTask'] == ''
            ? null
            : OrderTaskDataModel.fromJson(json['orderTask']));
  }
}

class OrderTaskDataModel extends OrderTaskDataResponse {
  OrderTaskDataModel(
      {required super.buyerId,
      required super.mechanicId,
      required super.orderId,
      required super.latitude,
      required super.longitude,
      required super.orderStatus});

  factory OrderTaskDataModel.fromJson(Map<String, dynamic> json) {
    return OrderTaskDataModel(
        buyerId: json['buyerId'] as String,
        mechanicId: json['mechanicId'] as String,
        orderId: json['orderId'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        orderStatus: json['orderStatus'] as String);
  }
}
