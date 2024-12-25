import 'package:santai_technician/app/data/models/chat/conversation.dart';
import 'package:santai_technician/app/domain/entities/chat/chat_contact.dart';

abstract class ChatRepository {
  Future<List<ChatContact>?> getUserByUserType();
  Future<ConversationResponseModel?> getConversationsByOrderId(
      String orderId, int lastTimestamp, bool forward);
}
