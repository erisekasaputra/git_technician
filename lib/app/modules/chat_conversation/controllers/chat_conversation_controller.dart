import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/chat/get_chat_conversations.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/helpers/conversation_sqlite.dart';
import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class ChatConversationController extends GetxController {
  final isLoading = false.obs;
  final Logout logout = Logout();
  final conversationDb = ConversationSqlite.instance;
  final SessionManager sessionManager = SessionManager();
  final ChatSignalRService chatService = Get.find<ChatSignalRService>();
  final me = Rx<types.User?>(null);
  final he = Rx<types.User?>(null);
  final lastTimestamp = 0.obs;

  final userId = ''.obs;
  final userName = ''.obs;
  final orderId = ''.obs;
  final buyerId = ''.obs;
  final buyerName = ''.obs;
  final buyerImageUrl = ''.obs;

  final commonImageUrl = ''.obs;

  final GetChatConversationsByOrderId getChatConversationByOrderId;

  ChatConversationController({required this.getChatConversationByOrderId});

  @override
  void onInit() async {
    super.onInit();
    await initializeChat();
    commonImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

    debounce(chatService.contacts, (updatedContacts) {
      int indexFoundContact = chatService.contacts
          .indexWhere((element) => element.orderId == orderId.value);
      bool isContactFound = indexFoundContact != -1;

      if (isContactFound) {
        buyerId.value =
            chatService.contacts[indexFoundContact].buyerId.value.toString();
        buyerName.value =
            chatService.contacts[indexFoundContact].buyerName.value.toString();
        buyerImageUrl.value = chatService
            .contacts[indexFoundContact].buyerImageUrl.value
            .toString();

        he.value = types.User(
            id: buyerId.value,
            firstName: buyerName.value,
            imageUrl: buyerImageUrl.value);
      }
    }, time: const Duration(seconds: 1));

    await chatService.initializeConnection();
  }

  types.TextMessage convertToTextMessage(ConversationResponse response) {
    return types.TextMessage(
      id: response.messageId,
      author: types.User(id: response.originUserId),
      text: response.text,
      createdAt: response.timestamp,
      metadata: {
        'orderId': response.orderId,
        'destinationUserId': response.destinationUserId,
        'attachment': response.attachment,
        'replyMessageId': response.replyMessageId,
        'replyMessageText': response.replyMessageText,
      },
    );
  }

  Future<void> initializeChat() async {
    try {
      userId.value =
          await sessionManager.getSessionBy(SessionManagerType.userId);
      userName.value =
          await sessionManager.getSessionBy(SessionManagerType.userName);

      orderId.value = Get.arguments?['orderId'] ?? '';
      buyerId.value = (Get.arguments?['buyerId'] ?? '').toString();
      buyerName.value = (Get.arguments?['buyerName'] ?? '').toString();
      buyerImageUrl.value = (Get.arguments?['buyerImageUrl'] ?? '').toString();

      me.value = types.User(id: userId.value);
      he.value = types.User(
        id: buyerId.value,
        firstName: buyerName.value,
        imageUrl: buyerImageUrl.value,
      );

      await loadInitialMessages();

      he.refresh();
      me.refresh();
    } catch (e) {
      CustomToast.show(message: e.toString(), type: ToastType.error);
    }
  }

  Future<void> loadInitialMessages() async {
    try {
      isLoading.value = true;
      chatService.messages.clear();

      var lastConversations =
          await conversationDb.getConversationsByOrderId(orderId.value);

      if (lastConversations.isNotEmpty) {
        lastTimestamp.value = lastConversations.last.timestamp;

        for (var storedConversation in lastConversations) {
          if (chatService.messages.indexWhere((element) =>
                  element.messageId == storedConversation.messageId) ==
              -1) {
            chatService.messages.insert(0, storedConversation);
          }
        }
      }

      chatService.messages.refresh();
      var chatResults = await getChatConversationByOrderId(
          orderId.value, lastTimestamp.value, true);
      if (chatResults == null || chatResults.data.isEmpty) {
        return;
      }

      for (var conver in chatResults.data) {
        if (!await conversationDb
            .anyConversationByMessageId(conver.messageId)) {
          await conversationDb.insertConversation(ConversationResponse(
              messageId: conver.messageId,
              orderId: conver.orderId,
              originUserId: conver.originUserId,
              destinationUserId: conver.destinationUserId,
              text: conver.text,
              timestamp: conver.timestamp));
        }
        if (chatService.messages
                .indexWhere((elemen) => elemen.messageId == conver.messageId) ==
            -1) {
          chatService.messages.insert(
              0,
              ConversationResponse(
                  messageId: conver.messageId,
                  orderId: conver.orderId,
                  originUserId: conver.originUserId,
                  destinationUserId: conver.destinationUserId,
                  text: conver.text,
                  timestamp: conver.timestamp));
        }
      }
    } catch (e) {
      if (e is CustomHttpException) {
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }
        CustomToast.show(message: e.message, type: ToastType.error);
        return;
      }
      CustomToast.show(
        message: "Uh-oh, there is an issue.",
        type: ToastType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleSendPressed(types.PartialText message) {
    try {
      if (orderId.value.isEmpty) {
        CustomToast.show(message: 'Invalid order id', type: ToastType.error);
        return;
      }

      chatService.sendMessage(orderId.value, he.value!.id, message.text,
          attachment: null, // Add other attachments if required
          replyMessageId: null, // Add reply message ID if replying
          replyMessageText: null // Add reply message text if replying
          );
    } catch (e) {
      CustomToast.show(
          message: 'Failed to send message. Please try again shortly.',
          type: ToastType.error);
    }
  }

  String formatDateTime(int? milliseconds) {
    if (milliseconds == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool shouldShowDateSeparator(
      types.Message message, types.Message? previousMessage) {
    if (previousMessage == null) return true;
    final messageDate = DateTime.fromMillisecondsSinceEpoch(message.createdAt!);
    final previousMessageDate =
        DateTime.fromMillisecondsSinceEpoch(previousMessage.createdAt!);
    return !isSameDay(messageDate, previousMessageDate);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
