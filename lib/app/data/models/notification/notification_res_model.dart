// Define the Notify entity class
import 'package:santai_technician/app/core/base_response.dart';
import 'package:santai_technician/app/domain/entities/notification/notify.dart';

// Define the response model class for the Notify entity
class NotifyResponseModel extends BaseResponse<List<Notify>> {
  NotifyResponseModel({
    required super.isSuccess,
    required List<NotifyResponseDataModel> super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  // Factory constructor to create an instance from JSON
  factory NotifyResponseModel.fromJson(Map<String, dynamic> json) {
    final rawNotifications = json['data'];
    List<NotifyResponseDataModel> parsedNotifications = [];

    if (rawNotifications is List) {
      parsedNotifications = rawNotifications
          .map((item) => NotifyResponseDataModel.fromJson(item))
          .toList();
    }

    return NotifyResponseModel(
      isSuccess: json['isSuccess'],
      data: parsedNotifications,
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class NotifyResponseDataModel extends Notify {
  NotifyResponseDataModel(
      {required super.notificationId,
      required super.belongsTo,
      required super.type,
      required super.title,
      required super.body,
      required super.timestamp});

  factory NotifyResponseDataModel.fromJson(Map<String, dynamic> json) {
    return NotifyResponseDataModel(
      notificationId: json['notificationId'],
      belongsTo: json['belongsTo'],
      type: json['type'],
      title: json['title'],
      body: json['body'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}
