import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/usecases/order/pre_service_inspection.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';

class DetailInspectionController extends GetxController {
  final isLoading = false.obs;
  final Logout logout = Logout();
  final HomeController? homeController =
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

  final orderData = Rx<OrderResponseModel?>(null);
  final preServiceInspections = RxList<PreServiceInspectionObject>([]);

  final PreServiceInspectionUseCase preServiceInspectionUseCase;

  DetailInspectionController({required this.preServiceInspectionUseCase});

  @override
  void onInit() async {
    super.onInit();
    if (homeController == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    orderData.value = homeController!.orderData.value;

    if (orderData.value != null) {
      preServiceInspections.value = orderData
          .value!.data.fleets.first.preServiceInspections
          .map((elemen) => PreServiceInspectionObject(
              description: elemen.description,
              parameter: elemen.parameter,
              rating: elemen.rating.obs,
              preServiceInspectionResults: elemen.preServiceInspectionResults
                  .map((toElement) => PreServiceInspectionResultObject(
                      description: toElement.description,
                      parameter: toElement.parameter,
                      isWorking: toElement.isWorking.obs))
                  .toList()))
          .toList();
    }

    await Future.delayed(const Duration(seconds: 2));

    ever(homeController!.orderData, (data) {
      orderData.value = data;
    });
  }

  void setStatus<T>(Map<T, bool> statusMap, T key, bool value) {
    statusMap[key] = value;
  }

  bool getStatus<T>(Map<T, bool> statusMap, T key) {
    return statusMap[key] ?? false;
  }

  void setRating(String key, int value) {
    final index = preServiceInspections
        .indexWhere((inspection) => inspection.parameter == key);
    if (index != -1) {
      preServiceInspections[index].rating.value = value;
    }
    preServiceInspections.refresh();
  }

  int getRating(String key) {
    final index = preServiceInspections
        .indexWhere((inspection) => inspection.parameter == key);
    if (index != -1) {
      return preServiceInspections[index].rating.value;
    }
    preServiceInspections.refresh();
    return -0;
  }

  void setCondition(String parentKey, String childKey, bool newValue) {
    final index = preServiceInspections
        .indexWhere((inspection) => inspection.parameter == parentKey);
    if (index == -1) {
      return;
    }

    final indexChild = preServiceInspections[index]
        .preServiceInspectionResults
        .indexWhere(
            (resultInspection) => resultInspection.parameter == childKey);
    if (indexChild == -1) {
      return;
    }

    preServiceInspections[index]
        .preServiceInspectionResults[indexChild]
        .isWorking
        .value = newValue;
    preServiceInspections.refresh();
  }

  bool getCondition(String parentKey, String childKey) {
    final index = preServiceInspections
        .indexWhere((inspection) => inspection.parameter == parentKey);
    if (index == -1) {
      return false;
    }

    final indexChild = preServiceInspections[index]
        .preServiceInspectionResults
        .indexWhere(
            (resultInspection) => resultInspection.parameter == childKey);
    if (indexChild == -1) {
      return false;
    }
    preServiceInspections.refresh();
    return preServiceInspections[index]
        .preServiceInspectionResults[indexChild]
        .isWorking
        .value;
  }

  Future<void> nextPage() async {
    isLoading.value = true;
    try {
      if (orderData.value?.data == null) {
        return;
      }

      bool result = await preServiceInspectionUseCase(
          orderData.value!.data.orderId,
          orderData.value!.data.fleets.first.fleetId,
          preServiceInspections
              .map((elemen) => PreServiceInspection(
                  description: elemen.description,
                  parameter: elemen.parameter,
                  rating: elemen.rating.value,
                  preServiceInspectionResults: elemen
                      .preServiceInspectionResults
                      .map((toElement) => PreServiceInspectionResult(
                          description: toElement.description,
                          parameter: toElement.parameter,
                          isWorking: toElement.isWorking.value))
                      .toList()))
              .toList());

      if (result) {
        Get.toNamed(Routes.JOB_CHECKLIST);
        return;
      }
      CustomToast.show(
          message: 'Can not proceed to next step', type: ToastType.error);
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
    } finally {
      isLoading.value = false;
    }
  }
}

class PreServiceInspectionObject {
  final String description;
  final String parameter;
  RxInt rating;
  final List<PreServiceInspectionResultObject> preServiceInspectionResults;

  PreServiceInspectionObject({
    required this.description,
    required this.parameter,
    required this.rating,
    required this.preServiceInspectionResults,
  });
}

class PreServiceInspectionResultObject {
  final String description;
  final String parameter;
  RxBool isWorking;

  PreServiceInspectionResultObject({
    required this.description,
    required this.parameter,
    required this.isWorking,
  });
}
