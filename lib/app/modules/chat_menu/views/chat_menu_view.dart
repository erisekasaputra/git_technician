import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_menu_controller.dart';

class ChatMenuView extends GetView<ChatMenuController> {
  const ChatMenuView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatMenuView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChatMenuView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
