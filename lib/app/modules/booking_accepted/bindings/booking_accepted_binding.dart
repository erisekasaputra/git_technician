import 'package:get/get.dart';

import '../controllers/booking_accepted_controller.dart';

class BookingAcceptedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingAcceptedController>(
      () => BookingAcceptedController(),
    );
  }
}
