import 'package:santai_technician/app/data/datasources/notification/notification_remote_data_source.dart';
import 'package:santai_technician/app/data/models/notification/notification_res_model.dart';
import 'package:santai_technician/app/domain/repository/notification/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NotifyResponseModel?> getNotificationsByTimestamp(
      int lastTimestamp) async {
    try {
      final response =
          await remoteDataSource.getNotificationsByLastTimestamp(lastTimestamp);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
