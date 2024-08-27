import 'package:get/get.dart';

import '../controllers/job_checklist_controller.dart';

class JobChecklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobChecklistController>(
      () => JobChecklistController(),
    );
  }
}
