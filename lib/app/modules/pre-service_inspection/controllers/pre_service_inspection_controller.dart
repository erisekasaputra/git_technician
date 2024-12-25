import 'package:get/get.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/fleet/fleet_res.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/usecases/order/basic_inspection.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_fleet_by_id.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';
import 'package:santai_technician/app/utils/session_manager.dart';

class PreServiceInspectionController extends GetxController {
  final Logout logout = Logout();
  final HomeController? homeController =
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
  final SessionManager sessionManager = SessionManager();

  final GetFleetById getFleetById;
  final BasicInspectionUseCase basicInspectionUseCase;

  final fleet = Rx<FleetUserResponseModel?>(null);

  PreServiceInspectionController(
      {required this.getFleetById, required this.basicInspectionUseCase});

  final basicInspectionScores = RxList<BasicInspection>([]);
  final basicInspectionMiddle = 0.obs;
  final basicInspection1 = RxList<BasicInspection>([]);
  final basicInspection2 = RxList<BasicInspection>([]);

  final orderData = Rx<OrderResponseModel?>(null);

  final serviceProgresses = <ServiceProgress>[].obs;
  final currentServiceIndex = 0.obs;

  final isInspectionLoading = false.obs;
  final isNextLoading = false.obs;
  final commonUrlAssetInternet = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    if (homeController == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }

    commonUrlAssetInternet.value =
        await sessionManager.getSessionBy(SessionManagerType.commonFileUrl);

    orderData.value = homeController!.orderData.value;
    await loadData(orderData.value);

    if (orderData.value != null) {
      basicInspectionScores.value =
          orderData.value!.data.fleets.first.basicInspections;

      basicInspectionMiddle.value =
          (orderData.value!.data.fleets.first.basicInspections.length / 2)
              .ceil();

      basicInspection1.value = orderData
          .value!.data.fleets.first.basicInspections
          .sublist(0, basicInspectionMiddle.value);

      if (orderData.value!.data.fleets.first.basicInspections.length > 1) {
        basicInspection2.value = orderData
            .value!.data.fleets.first.basicInspections
            .sublist(basicInspectionMiddle.value);
      }
    }

    await Future.delayed(const Duration(seconds: 2));

    ever(homeController!.orderData, (data) {
      orderData.value = data;
    });
  }

  Future<void> loadData(OrderResponseModel? orderData) async {
    if (orderData?.data.buyer.buyerId == null ||
        orderData?.data.fleets.first.fleetId == null) {
      return;
    }

    try {
      fleet.value = await getFleetById(
          orderData!.data.buyer.buyerId, orderData.data.fleets.first.fleetId);

      if (fleet.value == null) {
        CustomToast.show(
            message: 'Uh, oh. We can not find the fleet details',
            type: ToastType.error);
        return;
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

  void updateInspectionScore(String item, int score) {
    final index = basicInspectionScores
        .indexWhere((inspection) => inspection.parameter == item);

    if (index != -1) {
      basicInspectionScores[index].value = score;
      basicInspectionScores.refresh();
    }
  }

  Future<void> onInspectionPressed() async {
    isInspectionLoading.value = true;
    Get.toNamed(Routes.DETAIL_INSPECTION);
    isInspectionLoading.value = false;
  }

  Future<void> onNextPressed() async {
    isNextLoading.value = true;
    try {
      if (orderData.value?.data == null) {
        return;
      }

      bool result = await basicInspectionUseCase(orderData.value!.data.orderId,
          orderData.value!.data.fleets.first.fleetId, basicInspectionScores);

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
      isNextLoading.value = false;
    }
  }
}

class ServiceProgress {
  final List<ServiceStep> steps;
  final int currentStep;

  ServiceProgress({required this.steps, required this.currentStep});
}

class ServiceStep {
  final String label;
  final bool isCompleted;

  ServiceStep({required this.label, required this.isCompleted});
}
