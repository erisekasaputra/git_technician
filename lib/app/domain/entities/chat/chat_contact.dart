class ChatContact {
  final String orderId;
  final int lastChatTimestamp;
  final String buyerId;
  final String buyerName;
  final String buyerImageUrl;
  String? mechanicId;
  String? mechanicName;
  String? mechanicImageUrl;
  String? lastChatText;
  String? chatOriginUserId;
  DateTime? orderCompletedAtUtc;
  DateTime? orderChatExpiredAtUtc;
  bool isOrderCompleted;
  int chatUpdateTimestamp;
  bool isChatExpired;

  ChatContact({
    required this.orderId,
    required this.lastChatTimestamp,
    required this.buyerId,
    required this.buyerName,
    required this.buyerImageUrl,
    this.mechanicId,
    this.mechanicName,
    this.mechanicImageUrl,
    this.lastChatText,
    this.chatOriginUserId,
    this.orderCompletedAtUtc,
    this.orderChatExpiredAtUtc,
    this.isOrderCompleted = false,
    required this.chatUpdateTimestamp,
    this.isChatExpired = false,
  });
}
