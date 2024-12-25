import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_back_button.dart';
import 'package:santai_technician/app/modules/chat_contact/controllers/chat_contact_controller.dart';
import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:santai_technician/app/utils/custom_date_extension.dart';

class ChatContactView extends GetView<ChatContactController> {
  const ChatContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Obx(() => controller.isNotificationTab.value
            //     ? const SizedBox.shrink()
            //     : _buildSearchBar(context)),
            const SizedBox(height: 16),
            _buildTabButtons(context),
            const SizedBox(height: 16),
            Obx(() => controller.isNotificationTab.value
                ? _buildNotificationList(context)
                : _buildChatList(context)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 0, 8),
        child: CustomBackButton(
          onPressed: () => Get.back(),
        ),
      ),
      leadingWidth: 100,
      title: const Text(
        'Inbox',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTabButtons(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Obx(() => ElevatedButton(
                  onPressed: () => controller.toggleTab(false),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: controller.isNotificationTab.value
                        ? Colors.black
                        : Colors.white,
                    backgroundColor: controller.isNotificationTab.value
                        ? Colors.white
                        : primary_300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  child: Text('Inbox',
                      style: TextStyle(
                        color: controller.isNotificationTab.value
                            ? Colors.black
                            : Colors.white,
                      )),
                )),
          ),
        ),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: () => controller.toggleTab(true),
              style: ElevatedButton.styleFrom(
                foregroundColor: controller.isNotificationTab.value
                    ? Colors.white
                    : Colors.black,
                backgroundColor: controller.isNotificationTab.value
                    ? primary_300
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: controller.isNotificationTab.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Expanded(
      child: Obx(
        () => RefreshIndicator(
          onRefresh: controller
              .fetchNotifications, // Panggil metode refresh di controller
          child: ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Divider(height: 1, color: borderColor),
            ),
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Obx(
                    () => controller.isNotificationLoading.value
                        ? Container(
                            width: 24,
                            height: 40,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 4.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                              backgroundColor: Colors.white,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: controller.isNotificationLoading.value
                                ? null
                                : controller.fetchNotifications,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1),
                                side: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                            ),
                            child: const Text('Load More'),
                          ),
                  ),
                );
              }

              final notification = controller.notifications[index];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/company_logo.png'),
                      fit: BoxFit.scaleDown,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  notification.type,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                    '${notification.body}\r\n${controller.miliEpochToDate(notification.timestamp).toHumanReadable()}'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;
    return Expanded(
      child: Obx(() => ListView.separated(
            itemCount: controller.chatService?.contacts.length ?? 0,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: borderColor),
            itemBuilder: (context, index) {
              final chat = controller.chatService?.contacts[index];
              if (chat == null) {
                return const SizedBox.shrink();
              }
              return _buildChatListItem(context, chat);
            },
          )),
    );
  }

  Widget _buildChatListItem(BuildContext context, ChatContactResponse chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          backgroundImage: (chat.buyerImageUrl.value.isEmpty
              ? null
              : Image.network(
                      '${controller.commonImageUrl.value}${chat.buyerImageUrl.value}')
                  .image),
          child: chat.buyerImageUrl.value.isEmpty
              ? const Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                )
              : null,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${chat.orderId.substring(0, 8).toUpperCase()}',
              style: TextStyle(
                color: chat.isChatExpired.value ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w900,
              ),
              softWrap: true, // memungkinkan teks membungkus
              overflow: TextOverflow.visible, // memastikan teks tidak terpotong
            ),
            Text(
              'Owner: ${chat.buyerName.value}',
              style: TextStyle(
                color: chat.isChatExpired.value ? Colors.grey : Colors.black,
                fontWeight: FontWeight.normal,
              ),
              softWrap: true, // memungkinkan teks membungkus
              overflow: TextOverflow.visible, // memastikan teks tidak terpotong
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Menyusun elemen ke kiri
          crossAxisAlignment: CrossAxisAlignment
              .center, // Menyusun elemen secara vertikal di tengah
          children: [
            if (chat.lastChatText.value.isNotEmpty) ...[
              const Icon(
                Icons.arrow_right,
                size: 20,
                color: Colors.blue,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                chat.lastChatText.value,
                style: TextStyle(
                  color: chat.isChatExpired.value ? Colors.grey : Colors.black,
                ),
              ),
            ]
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // if (chat.unreadCount > 0)
            //   Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: alert_300,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       chat.unreadCount.toString(),
            //       style: const TextStyle(color: Colors.white),
            //     ),
            //   ),
            const SizedBox(height: 4),
            Text(
              '',
              style: TextStyle(
                color: chat.isChatExpired.value ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
        onTap: () =>
            chat.isChatExpired.value ? null : controller.openChat(chat),
      ),
    );
  }
}
