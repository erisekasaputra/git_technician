import 'package:santai_technician/app/data/models/chat/conversation.dart';
import 'package:santai_technician/app/domain/repository/chat/chat_repository.dart';

class GetChatConversationsByOrderId {
  final ChatRepository repository;

  GetChatConversationsByOrderId(this.repository);
  Future<ConversationResponseModel?> call(
      String orderId, int lastTimestamp, bool forward) async {
    try {
      return await repository.getConversationsByOrderId(
          orderId, lastTimestamp, forward);
    } catch (e) {
      rethrow;
    }
  }
}
