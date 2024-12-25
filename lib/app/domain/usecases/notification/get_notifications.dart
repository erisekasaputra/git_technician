import 'package:santai_technician/app/data/models/notification/notification_res_model.dart';
import 'package:santai_technician/app/domain/repository/notification/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);
  Future<NotifyResponseModel?> call(int lastTimestamp) async {
    try {
      return await repository.getNotificationsByTimestamp(lastTimestamp);
    } catch (e) {
      rethrow;
    }
  }
}
