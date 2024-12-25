import 'package:flutter/widgets.dart';
import 'package:santai_technician/app/config/api_config.dart';
import 'package:santai_technician/app/services/refresh_token.dart';
import 'package:santai_technician/app/utils/order_status.dart';
import 'package:santai_technician/app/utils/session_manager.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:uuid/uuid.dart';

class SignalRService extends GetxService with WidgetsBindingObserver {
  final lockSignalR = false.obs;
  HubConnection? _hubConnection;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final SessionManager sessionManager = SessionManager();
  bool isRefreshingToken = false;
  final _reconnectAttempt = 0.obs;
  bool get isConnected => _hubConnection?.state == HubConnectionState.connected;
  final forceRefresh =
      ("${DateTime.now().toUtc().millisecondsSinceEpoch}-${const Uuid().v4().toString()}")
          .obs;

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

        forceRefresh.value =
            "${DateTime.now().toUtc().millisecondsSinceEpoch}-${const Uuid().v4().toString()}";
      } catch (_) {}
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

      var url = ApiConfigNotificationSocket.baseUrl;
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

      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _startConnection();
    }
  }

  // Future<void> _handleConnectionError(Object error) async {
  //   if (_reconnectAttempt.value >= _maxReconnectAttempts) {
  //     CustomToast.show(
  //         message:
  //             'Failed to connect to SignalR server after multiple attempts',
  //         type: ToastType.error);
  //     return;
  //   }

  //   var delay = Duration(
  //       seconds:
  //           _reconnectDelay[_reconnectAttempt.value % _reconnectDelay.length]);
  //   _reconnectAttempt.value += 1;

  //   await Future.delayed(delay);
  //   await _startConnection();
  // }

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

    _hubConnection?.on(
        "ReceiveOrderStatusUpdate", _handleReceiveOrderStatusUpdate);
  }

  void _handleReceiveOrderStatusUpdate(List<Object?>? message) {
    if (lockSignalR.value) return;
    if (message != null && message.isNotEmpty) {
      try {
        if (message.length == 7) {
          final order = OrderResponse(
              orderId: message[0] as String,
              buyerId: message[1] as String,
              buyerName: message[2] as String,
              mechanicId: message[3] as String,
              mechanicName: message[4] as String,
              orderStatus: message[5] as String,
              actionUrl: message[6] as String);

          if (order.orderStatus == OrderStatus.mechanicSelected) {
            forceRefresh.value =
                "${DateTime.now().toUtc().millisecondsSinceEpoch}-${const Uuid().v4().toString()}";
          } else if (order.orderStatus ==
              OrderStatus.orderCancelledByMechanic) {
          } else if (order.orderStatus == OrderStatus.orderCancelledByUser) {
            forceRefresh.value =
                "${DateTime.now().toUtc().millisecondsSinceEpoch}-${const Uuid().v4().toString()}";
          } else if (order.orderStatus == OrderStatus.findingMechanic) {
          } else if (order.orderStatus == OrderStatus.mechanicArrived) {
          } else if (order.orderStatus == OrderStatus.mechanicAssigned) {
          } else if (order.orderStatus == OrderStatus.mechanicDispatched) {
          } else if (order.orderStatus == OrderStatus.serviceIncompleted) {
          } else if (order.orderStatus == OrderStatus.serviceCompleted) {
          } else if (order.orderStatus == OrderStatus.serviceInProgress) {
          } else if (order.orderStatus == OrderStatus.paymentPaid) {
          } else if (order.orderStatus == OrderStatus.paymentPending) {}
        }
      } catch (_) {}
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

class OrderResponse {
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String mechanicId;
  final String mechanicName;
  final String orderStatus;
  final String actionUrl;

  OrderResponse(
      {required this.orderId,
      required this.buyerId,
      required this.buyerName,
      required this.mechanicId,
      required this.mechanicName,
      required this.orderStatus,
      required this.actionUrl});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
        orderId: json['orderId'] ?? '',
        buyerId: json['buyerId'] ?? '',
        buyerName: json['buyerName'] ?? '',
        mechanicId: json['mechanicId'] ?? '',
        mechanicName: json['mechanicName'] as String,
        orderStatus: json['orderStatus'] as String,
        actionUrl: json['actionUrl'] as String);
  }
}
