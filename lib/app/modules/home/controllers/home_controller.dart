import 'package:get/get.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/notification_service.dart';

class HomeController extends GetxController {
  final isOnline = false.obs;
  final currentIndex = 0.obs;
  final isOrderPopupVisible = false.obs;
  final NotificationService _notificationService = Get.find<NotificationService>();

  void changeTab(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed(Routes.REWARD);
        break;
      case 1:
        Get.toNamed(Routes.JOB_HISTORY);
        break;
      case 2:
        Get.toNamed(Routes.SETTINGS);
        break;
      case 3:
        Get.toNamed(Routes.FINANCIAL);
        break;
      case 4:
        Get.toNamed(Routes.SUPPORT_SCREEN);
        break;
    }
  }

  void toggleOnlineStatus(bool value) {
    isOnline.value = value;
    if (value) {
      Future.delayed(Duration(seconds: 3), () {
        isOrderPopupVisible.value = true;
        _showOrderNotification();
      });
    } else {
      isOrderPopupVisible.value = false;
    }

  }

void _showOrderNotification() {
  print("Attempting to show order notification");
  _notificationService.showOrderNotification(
    id: 0,
    title: 'New Order!',
    body: 'You have a new order request.',
  );
  print("Order notification method called");
}

void handleNotificationAction(String? payload) {
  if (payload == 'accept') {
    acceptOrder();
  } else if (payload == 'reject') {
    rejectOrder();
  }
}

  void acceptOrder() {
    isOrderPopupVisible.value = false;
    
    Get.snackbar('Order Accepted', 'You have accepted the order.');
    Get.toNamed(Routes.BOOKING_ACCEPTED);
  }

  void rejectOrder() {
    isOrderPopupVisible.value = false;
   
    Get.snackbar('Order Rejected', 'You have rejected the order.');
  }
  
}