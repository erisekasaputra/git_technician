import 'package:flutter/widgets.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/helpers/conversation_sqlite.dart';
import 'package:santai_technician/app/services/refresh_token.dart';
import 'package:santai_technician/app/utils/session_manager.dart';
import 'package:santai_technician/app/utils/unique_identifier.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatSignalRService extends GetxService with WidgetsBindingObserver {
  final conversationDb = ConversationSqlite.instance;
  final lockSignalR = false.obs;
  HubConnection? _hubConnection;
  final messages = <ConversationResponse>[].obs;
  final contacts = <ChatContactResponse>[].obs;
  final filteredContacts = <ChatContactResponse>[].obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final SessionManager sessionManager = SessionManager();
  bool isRefreshingToken = false;
  final _reconnectAttempt = 0.obs;
  bool get isConnected => _hubConnection?.state == HubConnectionState.connected;
  final forceRefresh = UniqueIdentifier.generateId().obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await initializeConnection();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      try {
        if (_hubConnection == null) {
          Future(() => initializeConnection());
          return;
        }

        if (_hubConnection != null) {
          Future(() => _startConnection());
        }
      } catch (_) {
      } finally {
        forceRefresh.value = UniqueIdentifier.generateId();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {}
  }

  Future<void> initializeConnection() async {
    try {
      if (_hubConnection != null) {
        if (_hubConnection!.state == HubConnectionState.disconnected) {
          await _startConnection();
        }
        return;
      }

      var url = ApiConfigChatSocket.baseUrl;
      var accessToken =
          await sessionManager.getSessionBy(SessionManagerType.accessToken);

      if (accessToken.isEmpty) {
        return;
      }

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            HttpConnectionOptions(
                transport: HttpTransportType.longPolling,
                accessTokenFactory: () async {
                  return await sessionManager
                      .getSessionBy(SessionManagerType.accessToken);
                }),
          )
          .withAutomaticReconnect()
          .build();

      _hubConnection?.keepAliveIntervalInMilliseconds =
          9 * 60 * 1000; // 9 menit
      _hubConnection?.serverTimeoutInMilliseconds = 11 * 60 * 1000; // 11 menit
      _addHubEventListeners();
      await _startConnection();
    } catch (_) {}
  }

  Future<void> _startConnection() async {
    if (_hubConnection == null) return;

    try {
      if (_hubConnection!.state == HubConnectionState.disconnected) {
        await _hubConnection!.start();
      }

      await Future.delayed(const Duration(milliseconds: 100));
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _startConnection();
    }
  }

  Future<void> _refreshTokenAndReconnect() async {
    if (isRefreshingToken) return;
    isRefreshingToken = true;

    var accessToken =
        await sessionManager.getSessionBy(SessionManagerType.accessToken);
    var refreshToken =
        await sessionManager.getSessionBy(SessionManagerType.refreshToken);
    var deviceId =
        await sessionManager.getSessionBy(SessionManagerType.deviceId);

    if (accessToken.isEmpty || refreshToken.isEmpty || deviceId.isEmpty) {
      isRefreshingToken = false;
      return;
    }

    try {
      var (statusCode, newAccessToken, newRefreshToken) =
          await requestRefreshToken(
              accessToken: accessToken,
              refreshToken: refreshToken,
              deviceId: deviceId,
              client: http.Client());

      if (newAccessToken == null || newRefreshToken == null) {
        return;
      }
      await sessionManager.setSessionBy(
          SessionManagerType.accessToken, newAccessToken);
      await sessionManager.setSessionBy(
          SessionManagerType.refreshToken, newRefreshToken);

      await _hubConnection?.stop();
      disposeSignalR();
      await initializeConnection();
    } finally {
      isRefreshingToken = false;
    }
  }

  Future<void> sendMessage(
    String orderId,
    String destinationUserId,
    String text, {
    String? attachment,
    String? replyMessageId,
    String? replyMessageText,
  }) async {
    if (_hubConnection == null) {
      await initializeConnection();
      if (_hubConnection == null) {
        return;
      }
    }

    try {
      if (_hubConnection!.state == HubConnectionState.disconnected) {
        await _startConnection();
      }
    } catch (_) {}

    int maxAttempts = 20;
    int attempt = 0;
    while (attempt < maxAttempts) {
      if (_hubConnection!.state != HubConnectionState.connected) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      try {
        await _hubConnection!.invoke("SendMessage", args: [
          {
            "OrderId": orderId,
            "DestinationUserId": destinationUserId,
            "Text": text,
            "Attachment": attachment ?? "",
            "ReplyMessageId": replyMessageId ?? "",
            "ReplyMessageText": replyMessageText ?? ""
          }
        ]);

        return;
      } catch (e) {
        attempt++;
        continue;
      }
    }
  }

  void _addHubEventListeners() {
    if (_hubConnection == null) return;

    _hubConnection?.onclose((error) async {
      var errorMessage = error.toString().toLowerCase();
      if (errorMessage.contains('401') ||
          errorMessage.contains('unauthorized')) {
        await _refreshTokenAndReconnect();
      } else {
        if (_hubConnection == null) {
          await initializeConnection();
        } else {
          await _startConnection();
        }
      }
    });

    _hubConnection?.onreconnecting((error) {
      isRefreshingToken = true;
    });

    _hubConnection?.onreconnected((connectionId) {
      isRefreshingToken = false;
      _reconnectAttempt.value = 0;
    });

    _hubConnection?.on("ReceiveMessage", _handleReceiveMessage);
    _hubConnection?.on("UpdateChatContact", _handleUpdateChatContact);
    _hubConnection?.on("ReceiveChatContact", _handleReceiveChatContact);
    _hubConnection?.on("DeleteChatContact", _handleDeleteChatContact);
    _hubConnection?.on("InternalServerError", _handleInternalServerError);
    _hubConnection?.on("ChatBadRequest", _handleChatBadRequest);
  }

  void _handleReceiveMessage(List<Object?>? message) async {
    if (lockSignalR.value) return;
    if (message != null && message.isNotEmpty) {
      try {
        final conversation = ConversationResponse.fromJson(
            Map<String, dynamic>.from(message[0] as Map));

        if (!await conversationDb
            .anyConversationByMessageId(conversation.messageId)) {
          await conversationDb.insertConversation(conversation);
        }
        if (messages.indexWhere(
                (elemen) => elemen.messageId == conversation.messageId) ==
            -1) {
          messages.insert(0, conversation);
          messages.refresh();
        }
      } catch (_) {}
    }
  }

  void _handleUpdateChatContact(List<Object?>? chatContact) {
    if (lockSignalR.value) return;
    if (chatContact != null && chatContact.isNotEmpty) {
      try {
        final json = Map<String, dynamic>.from(chatContact[0] as Map);

        var contact = ChatContactResponse(
          orderId: json['orderId'] ?? '',
          lastChatTimestamp:
              int.tryParse(json['lastChatTimestamp']?.toString() ?? '0') ?? 0,
          buyerId: ((json['buyerId'] ?? '').toString()).obs,
          buyerName: ((json['buyerName'] ?? '').toString()).obs,
          buyerImageUrl: ((json['buyerImageUrl'] ?? '').toString()).obs,
          mechanicId: ((json['mechanicId'] ?? '').toString()).obs,
          mechanicName: ((json['mechanicName'] ?? '').toString()).obs,
          mechanicImageUrl: ((json['mechanicImageUrl'] ?? '').toString()).obs,
          lastChatText: ((json['lastChatText'] ?? '').toString()).obs,
          chatOriginUserId: json['chatOriginUserId'] ?? '',
          orderCompletedAtUtc: json['orderCompletedAtUtc'],
          orderChatExpiredAtUtc: json['orderChatExpiredAtUtc'],
          isOrderCompleted: (json['isOrderCompleted'] ?? false),
          chatUpdateTimestamp:
              int.tryParse(json['chatUpdateTimestamp']?.toString() ?? '0') ?? 0,
          isChatExpired: RxBool(json['isChatExpired'] ?? false),
        );

        contacts.removeWhere(
            (iterateContact) => iterateContact.orderId == contact.orderId);
        if ((json['mechanicId'] ?? '').toString().isEmpty) {
          contacts.refresh();
          return;
        }

        contacts.insert(0, contact);
        contacts.refresh();
      } catch (_) {}
    }
  }

  void _handleReceiveChatContact(List<Object?>? chatContact) {
    if (lockSignalR.value) return;
    if (chatContact != null && chatContact.isNotEmpty) {
      try {
        final json = Map<String, dynamic>.from(chatContact[0] as Map);

        var contact = ChatContactResponse(
          orderId: json['orderId'] ?? '',
          lastChatTimestamp:
              int.tryParse(json['lastChatTimestamp']?.toString() ?? '0') ?? 0,
          buyerId: ((json['buyerId'] ?? '').toString()).obs,
          buyerName: ((json['buyerName'] ?? '').toString()).obs,
          buyerImageUrl: ((json['buyerImageUrl'] ?? '').toString()).obs,
          mechanicId: ((json['mechanicId'] ?? '').toString()).obs,
          mechanicName: ((json['mechanicName'] ?? '').toString()).obs,
          mechanicImageUrl: ((json['mechanicImageUrl'] ?? '').toString()).obs,
          lastChatText: ((json['lastChatText'] ?? '').toString()).obs,
          chatOriginUserId: json['chatOriginUserId'] ?? '',
          orderCompletedAtUtc: json['orderCompletedAtUtc'],
          orderChatExpiredAtUtc: json['orderChatExpiredAtUtc'],
          isOrderCompleted: (json['isOrderCompleted'] ?? false),
          chatUpdateTimestamp:
              int.tryParse(json['chatUpdateTimestamp']?.toString() ?? '0') ?? 0,
          isChatExpired: RxBool(json['isChatExpired'] ?? false),
        );

        if (!contacts.any(
            (iterateContact) => iterateContact.orderId == contact.orderId)) {
          if ((json['mechanicId'] ?? '').toString().isEmpty) {
            contacts.refresh();
            return;
          }
          contacts.insert(0, contact);
          contacts.refresh();
        }
      } catch (e) {}
    }
  }

  void _handleDeleteChatContact(List<Object?>? orderId) {
    if (lockSignalR.value) return;
    if (orderId != null && orderId.isNotEmpty) {
      contacts.removeWhere(
          (iterateContact) => iterateContact.orderId == orderId[0]);
      contacts.refresh();
    }
  }

  void _handleInternalServerError(List<Object?>? errorMessage) {
    if (errorMessage != null && errorMessage.isNotEmpty) {
      CustomToast.show(
          message: errorMessage[0].toString(), type: ToastType.error);
    }
  }

  void _handleChatBadRequest(List<Object?>? args) {
    if (args != null && args.length >= 2) {
      CustomToast.show(message: args[0].toString(), type: ToastType.error);
    }
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection?.stop();
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
  }

  void disposeSignalR() {
    _hubConnection = null;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
    disconnect();
    disposeSignalR();
  }
}

// models/conversation_response.dart
class ConversationResponse {
  String messageId;
  String orderId;
  String originUserId;
  String destinationUserId;
  String text;
  String? attachment;
  String? replyMessageId;
  String? replyMessageText;
  int timestamp;

  ConversationResponse({
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

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      messageId: json['messageId'] ?? '',
      orderId: json['orderId'] ?? '',
      originUserId: json['originUserId'] ?? '',
      destinationUserId: json['destinationUserId'] ?? '',
      text: json['text'] ?? '',
      attachment: json['attachment'] as String?,
      replyMessageId: json['replyMessageId'] as String?,
      replyMessageText: json['replyMessageText'] as String?,
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'orderId': orderId,
      'originUserId': originUserId,
      'destinationUserId': destinationUserId,
      'text': text,
      'attachment': attachment,
      'replyMessageId': replyMessageId,
      'replyMessageText': replyMessageText,
      'timestamp': timestamp,
    };
  }

  factory ConversationResponse.fromMap(Map<String, dynamic> map) {
    return ConversationResponse(
      messageId: map['messageId'] ?? '',
      orderId: map['orderId'] ?? '',
      originUserId: map['originUserId'] ?? '',
      destinationUserId: map['destinationUserId'] ?? '',
      text: map['text'] ?? '',
      attachment: map['attachment'],
      replyMessageId: map['replyMessageId'],
      replyMessageText: map['replyMessageText'],
      timestamp: map['timestamp'] ?? 0,
    );
  }
}

class ChatContactResponse {
  String orderId;
  int lastChatTimestamp;
  Rx<String> buyerId;
  Rx<String> buyerName;
  Rx<String> buyerImageUrl;
  Rx<String> mechanicId;
  Rx<String> mechanicName;
  Rx<String> mechanicImageUrl;
  Rx<String> lastChatText;
  String chatOriginUserId;
  String orderCompletedAtUtc;
  String orderChatExpiredAtUtc;
  bool isOrderCompleted;
  int chatUpdateTimestamp;
  RxBool isChatExpired;

  // Constructor
  ChatContactResponse({
    required this.orderId,
    required this.lastChatTimestamp,
    required this.buyerId,
    required this.buyerName,
    required this.buyerImageUrl,
    required this.mechanicId,
    required this.mechanicName,
    required this.mechanicImageUrl,
    required this.lastChatText,
    required this.chatOriginUserId,
    required this.orderCompletedAtUtc,
    required this.orderChatExpiredAtUtc,
    required this.isOrderCompleted,
    required this.chatUpdateTimestamp,
    required this.isChatExpired,
  });
}
