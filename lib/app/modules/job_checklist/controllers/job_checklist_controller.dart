import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/domain/usecases/order/complete_order.dart';
import 'package:santai_technician/app/domain/usecases/order/incomplete_order.dart';
import 'package:santai_technician/app/domain/usecases/order/job_checklist.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';

class JobChecklistController extends GetxController {
  final Logout logout = Logout();
  HomeController? homeController =
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
  final isLoading = false.obs;
  final orderId = ''.obs;
  final checklistItems = <ChecklistItem>[].obs;
  TextEditingController vehicleUpdateController = TextEditingController();

  final CompleteOrder completeOrder;
  final IncompleteOrder incompleteOrder;
  final JobChecklist jobChecklist;

  JobChecklistController(
      {required this.completeOrder,
      required this.incompleteOrder,
      required this.jobChecklist});

  @override
  void onInit() {
    super.onInit();
    if (homeController == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    var jobChecklists =
        homeController?.orderData.value?.data.fleets.first.jobChecklists;

    if (jobChecklists != null) {
      checklistItems.clear();
      List<ChecklistItem> items = [];
      for (var jobChecklist in jobChecklists) {
        items.add(ChecklistItem(jobChecklist.parameter,
            jobChecklist.description, jobChecklist.value.obs));
      }
      checklistItems.addAll(items);
      vehicleUpdateController.text =
          homeController?.orderData.value?.data.fleets.first.comment ?? '';
    }
  }

  @override
  void onClose() {
    vehicleUpdateController.dispose();
    super.onClose();
  }

  Future<void> completeOrderAction() async {
    try {
      if (homeController == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      var items = checklistItems
          .map((item) => {
                'parameter': item.parameter,
                'description': item.description,
                'value': item.isChecked.value,
              })
          .toList();

      if (items.isEmpty) {
        bool result = await completeOrder(
            homeController!.orderData.value!.data.orderId,
            homeController!.orderData.value!.data.secret,
            homeController!.orderData.value!.data.fleets.first.fleetId);

        if (result) {
          Get.toNamed(Routes.CONGRATULATION_SERVICE,
              arguments: {'status': 'success'});
          return;
        }
        CustomToast.show(
            message: 'Uh-oh, There is an issue', type: ToastType.error);
      } else {
        var result = await jobChecklist(
            homeController!.orderData.value!.data.orderId,
            homeController!.orderData.value!.data.fleets.first.fleetId,
            items,
            vehicleUpdateController.text);

        if (result) {
          var result2 = await completeOrder(
              homeController!.orderData.value!.data.orderId,
              homeController!.orderData.value!.data.secret,
              homeController!.orderData.value!.data.fleets.first.fleetId);

          if (result2) {
            Get.toNamed(Routes.CONGRATULATION_SERVICE,
                arguments: {'status': 'success'});
            return;
          }
          CustomToast.show(
              message: 'Uh-oh, There is an issue', type: ToastType.error);
        } else {
          CustomToast.show(
              message: 'Uh-oh, There is an issue', type: ToastType.error);
        }
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          var messageError = parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: '${error.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> incompleteOrderAction() async {
    try {
      if (homeController == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      var items = checklistItems
          .map((item) => {
                'parameter': item.parameter,
                'description': item.description,
                'value': item.isChecked.value,
              })
          .toList();

      if (items.isEmpty) {
        bool result = await incompleteOrder(
            homeController!.orderData.value!.data.orderId,
            homeController!.orderData.value!.data.secret,
            homeController!.orderData.value!.data.fleets.first.fleetId);

        if (result) {
          Get.toNamed(Routes.CONGRATULATION_SERVICE,
              arguments: {'status': 'failed'});
          return;
        }
        CustomToast.show(
            message: 'Uh-oh, There is an issue', type: ToastType.error);
      } else {
        var result = await jobChecklist(
            homeController!.orderData.value!.data.orderId,
            homeController!.orderData.value!.data.fleets.first.fleetId,
            items,
            vehicleUpdateController.text);

        if (result) {
          var result2 = await incompleteOrder(
              homeController!.orderData.value!.data.orderId,
              homeController!.orderData.value!.data.secret,
              homeController!.orderData.value!.data.fleets.first.fleetId);

          if (result2) {
            Get.toNamed(Routes.CONGRATULATION_SERVICE,
                arguments: {'status': 'failed'});
            return;
          }
          CustomToast.show(
              message: 'Uh-oh, There is an issue', type: ToastType.error);
        } else {
          CustomToast.show(
              message: 'Uh-oh, There is an issue', type: ToastType.error);
        }
      }
    } catch (error) {
      if (error is CustomHttpException) {
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          var messageError = parseErrorMessage(error.errorResponse!);
          CustomToast.show(
            message: '${error.message}$messageError',
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "An unexpected error has occured",
          type: ToastType.error,
        );
      }
    }
  }
}

class ChecklistItem {
  final String parameter;
  final String description;
  final RxBool isChecked;

  ChecklistItem(this.parameter, this.description, this.isChecked);
}
