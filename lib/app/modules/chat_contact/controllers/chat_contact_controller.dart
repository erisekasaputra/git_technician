import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/notification/notification_res_model.dart';
import 'package:santai_technician/app/domain/entities/notification/notify.dart';
import 'package:santai_technician/app/domain/usecases/chat/get_chat_contacts.dart';
import 'package:santai_technician/app/domain/usecases/notification/get_notifications.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/helpers/notification_sqlite.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/custom_date_extension.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class ChatContactController extends GetxController {
  final SessionManager sessionManager = SessionManager();
  final isNotificationLoading = false.obs;
  final Logout logout = Logout();
  final ChatSignalRService? chatService = Get.isRegistered<ChatSignalRService>()
      ? Get.find<ChatSignalRService>()
      : null;
  final notificationDb = NotificationSqlite.instance;
  final notifications = <Notify>[].obs;
  final isNotificationTab = false.obs;
  final timezone = ''.obs;
  final GetChatContactsByUserId getChatContacts;
  final GetNotifications getNotification;

  final commonImageUrl = ''.obs;

  final lastNotificationTimestamp = 0.obs;

  ChatContactController(
      {required this.getChatContacts, required this.getNotification});

  @override
  void onInit() async {
    super.onInit();
    commonImageUrl.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);
    if (chatService == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    timezone.value =
        await sessionManager.getSessionBy(SessionManagerType.timeZone);
    chatService!.contacts.clear();
    await loadChatData();
    debounce(chatService!.forceRefresh, (value) async {
      chatService!.contacts.clear();
      await loadChatData();
    }, time: const Duration(seconds: 1));
    await chatService!.initializeConnection();
  }

  Future loadChatData() async {
    if (chatService == null) {
      return;
    }
    var chatContacts = await getChatContacts();
    if (chatContacts != null && chatContacts.isNotEmpty) {
      for (var chatContact in chatContacts) {
        var indexExisting = chatService!.contacts
            .indexWhere((element) => element.orderId == chatContact.orderId);
        if (indexExisting != -1) {
          chatService!.contacts[indexExisting].mechanicId.value =
              (chatContact.mechanicId ?? '');
          chatService!.contacts[indexExisting].mechanicName.value =
              (chatContact.mechanicName ?? '');
          chatService!.contacts[indexExisting].mechanicImageUrl.value =
              (chatContact.mechanicImageUrl ?? '');

          chatService!.contacts[indexExisting].buyerId.value =
              (chatContact.buyerId);
          chatService!.contacts[indexExisting].buyerName.value =
              (chatContact.buyerName);
          chatService!.contacts[indexExisting].buyerImageUrl.value =
              (chatContact.buyerImageUrl);

          chatService!.contacts[indexExisting].lastChatText.value =
              (chatContact.lastChatText ?? '');
          chatService!.contacts[indexExisting].isOrderCompleted =
              chatContact.isOrderCompleted;
          chatService!.contacts[indexExisting].chatUpdateTimestamp =
              chatContact.chatUpdateTimestamp;
          chatService!.contacts[indexExisting].isChatExpired.value =
              chatContact.isChatExpired;
          return;
        }

        chatService!.contacts.add(
          ChatContactResponse(
            orderId: chatContact.orderId,
            lastChatTimestamp: chatContact.lastChatTimestamp,
            buyerId: chatContact.buyerId.obs,
            buyerName: chatContact.buyerName.obs,
            buyerImageUrl: chatContact.buyerImageUrl.obs,
            mechanicId: (chatContact.mechanicId ?? '').obs, // Correct for Rxn
            mechanicName:
                (chatContact.mechanicName ?? '').obs, // Correct for Rxn
            mechanicImageUrl:
                (chatContact.mechanicImageUrl ?? '').obs, // Correct for Rxn
            lastChatText: (chatContact.lastChatText ?? '').obs, // Rx<String>
            chatOriginUserId: chatContact.chatOriginUserId ?? '',
            isOrderCompleted: chatContact.isOrderCompleted,
            chatUpdateTimestamp: chatContact.chatUpdateTimestamp,
            isChatExpired: chatContact.isChatExpired.obs,
            orderChatExpiredAtUtc:
                chatContact.orderChatExpiredAtUtc.toString(), // Correct for Rxn
            orderCompletedAtUtc:
                chatContact.orderCompletedAtUtc.toString(), // Correct for Rxn
          ),
        );
      }
      chatService!.contacts.refresh();
    }
  }

  void toggleTab(bool isNotification) async {
    isNotificationTab.value = isNotification;

    if (isNotificationTab.value) {
      await fetchNotifications();
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isNotificationLoading.value = true;

      var userId = await sessionManager.getSessionBy(SessionManagerType.userId);
      if (userId.isEmpty) {
        return;
      }

      var localNotifications =
          await notificationDb.getNotificationsByUserId(userId);

      if (localNotifications.isNotEmpty) {
        for (var localNotification in localNotifications) {
          if (notifications.indexWhere((element) =>
                  element.notificationId == localNotification.notificationId) ==
              -1) {
            notifications.insert(0, localNotification);
          }
        }
        lastNotificationTimestamp.value = notifications.last.timestamp;
      }
      notifications.refresh();
      NotifyResponseModel? notificationsData;

      do {
        notificationsData =
            await getNotification(lastNotificationTimestamp.value);

        if (notificationsData != null) {
          for (var notificationData in notificationsData.data) {
            if (!await notificationDb.anyNotificationByNotificationId(
                notificationData.notificationId)) {
              await notificationDb.insertNotification(notificationData);
            }

            if (notifications.indexWhere((element) =>
                    element.notificationId ==
                    notificationData.notificationId) ==
                -1) {
              notifications.insert(0, notificationData);
            }
          }
          lastNotificationTimestamp.value =
              notificationsData.data.last.timestamp;
          notifications.refresh();
        }
      } while (notificationsData != null && notificationsData.data.isNotEmpty);
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
      isNotificationLoading.value = false;
    }
  }

  DateTime miliEpochToDate(int timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

    if (timezone.value.isEmpty) {
      throw Exception('Time zone has not been set');
    }

    return dateTime.utcToLocal(timezone.value);
  }

  void openChat(ChatContactResponse chat) {
    Get.toNamed(Routes.CHAT_CONVERSATION, arguments: {
      'orderId': chat.orderId,
      'buyerId': chat.buyerId,
      'buyerName': chat.buyerName,
      'buyerImageUrl': chat.buyerImageUrl,
      'mechanicId': chat.mechanicId,
      'mechanicName': chat.mechanicName,
      'mechanicImageUrl': chat.mechanicImageUrl,
    });
  }
}
