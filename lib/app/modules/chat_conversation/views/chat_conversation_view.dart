import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/chat_conversation_controller.dart';

class ChatConversationView extends GetView<ChatConversationController> {
  const ChatConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: borderColor,
          ),
        ),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Obx(
              () => CircleAvatar(
                backgroundImage: controller.he.value?.imageUrl?.isEmpty ?? true
                    ? null
                    : Image.network(
                            '${controller.commonImageUrl.value}${controller.he.value!.imageUrl}')
                        .image,
                child: controller.he.value?.imageUrl?.isEmpty ?? true
                    ? const Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  controller.he.value?.firstName ?? 'User',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 900,
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.call,
        //       color: primary_300,
        //       size: 30,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value || controller.me.value == null) {
            return const SizedBox.shrink();
          }

          return Chat(
            messages: controller.chatService.messages
                .map((element) => controller.convertToTextMessage(element))
                .toList(),
            onSendPressed: controller.handleSendPressed,
            user: controller.me.value!,
            theme: DefaultChatTheme(
              backgroundColor: Colors.white,
              messageBorderRadius: 8,
              messageInsetsHorizontal: 8,
              messageInsetsVertical: 4,
              primaryColor: Colors.white,
              secondaryColor: Colors.white,
              bubbleMargin: const EdgeInsets.all(10),
              inputBackgroundColor: Colors.white,
              inputTextColor: Colors.black,
              inputTextCursorColor: Colors.black,
              inputTextDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                contentPadding: const EdgeInsets.all(8),
                hintStyle: const TextStyle(color: Colors.black),
              ),
              sentMessageBodyTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 16),
              receivedMessageBodyTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 16),
              userAvatarNameColors: const [Colors.white],
              userNameTextStyle: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
