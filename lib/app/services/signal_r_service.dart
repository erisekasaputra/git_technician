import 'package:signalr_core/signalr_core.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SignalRService extends GetxService {
  HubConnection? _hubConnection;
  final _isConnected = false.obs;
  final messages = <String>[].obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initializeConnection(String url) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(url)
        .withAutomaticReconnect()
        .build();

    _hubConnection!.onclose((error) => _isConnected.value = false);
    _hubConnection!.onreconnecting((_) => _isConnected.value = false);
    _hubConnection!.onreconnected((_) => _isConnected.value = true);

    _hubConnection!.on("ReceiveMessage", (message) {
      if (message != null && message.isNotEmpty) {
        _handleNewMessage(message[0].toString());
      }
    });

    try {
      await _hubConnection!.start();
      _isConnected.value = true;
      print('SignalR Connected');
    } catch (e) {
      print('Error starting SignalR connection: $e');
      _isConnected.value = false;
    }
  }

  void _handleNewMessage(String message) {
    messages.add(message);
    _showNotification(message);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      message,
      platformChannelSpecifics,
    );
  }

  Future<void> sendMessage(String message) async {
    if (_hubConnection?.state == HubConnectionState.connected) {
      try {
        await _hubConnection!.invoke("SendMessage", args: [message]);
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('SignalR not connected. Cannot send message');
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null) {
      await _hubConnection!.stop();
      _isConnected.value = false;
      print('SignalR Disconnected');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}