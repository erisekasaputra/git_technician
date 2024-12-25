class Conversation {
  final String messageId;
  final String orderId;
  final String originUserId;
  final String destinationUserId;
  String text;
  String? attachment;
  String? replyMessageId;
  String? replyMessageText;
  final int timestamp;

  Conversation({
    required this.messageId,
    required this.orderId,
    required this.originUserId,
    required this.destinationUserId,
    required this.text,
    this.attachment,
    this.replyMessageId,
    this.replyMessageText,
    required this.timestamp,
  });
}
