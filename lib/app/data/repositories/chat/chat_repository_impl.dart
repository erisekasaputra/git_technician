import 'package:santai_technician/app/data/datasources/chat/chat_remote_data_source.dart';
import 'package:santai_technician/app/data/models/chat/conversation.dart';
import 'package:santai_technician/app/domain/entities/chat/chat_contact.dart';
import 'package:santai_technician/app/domain/repository/chat/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatContact>?> getUserByUserType() async {
    try {
      final response = await remoteDataSource.getChatContactsByUserType();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ConversationResponseModel?> getConversationsByOrderId(
      String orderId, int lastTimestamp, bool forward) async {
    try {
      final response = await remoteDataSource.getConversationsByOrderId(
          orderId, lastTimestamp, forward);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
