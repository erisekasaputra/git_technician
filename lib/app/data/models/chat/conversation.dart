import 'package:santai_technician/app/core/base_response.dart';
import 'package:santai_technician/app/domain/entities/chat/conversation.dart';

class ConversationResponseModel extends BaseResponse<List<Conversation>> {
  ConversationResponseModel({
    required super.isSuccess,
    required List<ConversationResponseDataModel> super.data,
    required super.message,
    required super.responseStatus,
    required super.errors,
    required super.links,
    super.next,
  });

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    final rawConversations = json['data']?['conversations'];
    List<ConversationResponseDataModel> parsedConversations = [];

    if (rawConversations is List) {
      parsedConversations = rawConversations
          .map((item) => ConversationResponseDataModel.fromJson(item))
          .toList();
    }

    return ConversationResponseModel(
      isSuccess: json['isSuccess'],
      data: parsedConversations,
      message: json['message'],
      responseStatus: json['responseStatus'],
      errors: json['errors'],
      links: json['links'],
      next: json['next'],
    );
  }
}

class ConversationResponseDataModel extends Conversation {
  ConversationResponseDataModel({
    required super.messageId,
    required super.orderId,
    required super.originUserId,
    required super.destinationUserId,
    required super.text,
    super.attachment,
    super.replyMessageId,
    super.replyMessageText,
    required super.timestamp,
  });

  // Factory constructor to create an instance from JSON
  factory ConversationResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ConversationResponseDataModel(
      messageId: json['messageId'],
      orderId: json['orderId'],
      originUserId: json['originUserId'],
      destinationUserId: json['destinationUserId'],
      text: json['text'] ?? '',
      attachment: json['attachment'],
      replyMessageId: json['replyMessageId'],
      replyMessageText: json['replyMessageText'],
      timestamp: json['timestamp'],
    );
  }
}
