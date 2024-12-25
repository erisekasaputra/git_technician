class MechanicExistenceResponse {
  final bool isSuccess;
  final MechanicExistenceDataResponse? data;
  final String message;
  final String responseStatus;
  final List<dynamic> errors;
  final List<dynamic> links;

  MechanicExistenceResponse({
    required this.isSuccess,
    required this.data,
    required this.message,
    required this.responseStatus,
    required this.errors,
    required this.links,
  });
}

class MechanicExistenceDataResponse {
  final String mechanicId;
  final double latitude;
  final double longitude;
  final String orderId;
  final String status;
  final int remainingTime;
  final OrderTaskDataResponse? orderTask;
  MechanicExistenceDataResponse(
      {required this.mechanicId,
      required this.latitude,
      required this.longitude,
      required this.orderId,
      required this.status,
      required this.remainingTime,
      this.orderTask});
}

class OrderTaskDataResponse {
  final String buyerId;
  final String mechanicId;
  final String orderId;
  final double latitude;
  final double longitude;
  final String orderStatus;
  OrderTaskDataResponse(
      {required this.buyerId,
      required this.mechanicId,
      required this.orderId,
      required this.latitude,
      required this.longitude,
      required this.orderStatus});
}
