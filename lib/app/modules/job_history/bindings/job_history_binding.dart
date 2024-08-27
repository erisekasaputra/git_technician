import 'package:get/get.dart';

import '../controllers/job_history_controller.dart';

class JobHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobHistoryController>(
      () => JobHistoryController(),
    );
  }
}
