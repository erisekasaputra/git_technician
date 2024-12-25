import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/profile/mechanic_existence_res.dart';
import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/domain/usecases/order/get_order_by_mechanic_id_and_order_id.dart';
import 'package:santai_technician/app/domain/usecases/profile/accept_order.dart';
import 'package:santai_technician/app/domain/usecases/profile/activate_mechanic_status.dart';
import 'package:santai_technician/app/domain/usecases/profile/deactivate_mechanic_status.dart';
import 'package:santai_technician/app/domain/usecases/profile/get_mechanic_existence.dart';
import 'package:santai_technician/app/domain/usecases/profile/reject_order.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/chat_signalr_service.dart';
import 'package:santai_technician/app/services/location_service.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/services/signal_r_service.dart';
import 'package:santai_technician/app/utils/camera_animator.dart';

class HomeController extends GetxController {
  final Logout logout = Logout();
  SignalRService? signalRService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;
  ChatSignalRService? chatSignalRService =
      Get.isRegistered<ChatSignalRService>()
          ? Get.find<ChatSignalRService>()
          : null;
  LocationService? locationService =
      Get.isRegistered<LocationService>() ? Get.find<LocationService>() : null;
  final isOnline = false.obs;
  final currentIndex = 0.obs;
  final isOrderPopupVisible = false.obs;
  final countdownTimer = 120.obs;
  final mechanicExistence = Rx<MechanicExistenceDataResponse?>(null);
  Timer? _countdownTimer;
  Timer? _locationTimer;
  final orderData = Rx<OrderResponseModel?>(null);
  final isStatusUpdating = false.obs;

  final initialCameraPosition = Rx<CameraPosition?>(null);
  GoogleMapController? mapController;

  final GetMechanicExistence getMechanicExistence;
  final ActivateMechanicStatus activateMechanicStatus;
  final DeactivateMechanicStatus deactivateMechanicStatus;
  final GetOrderByMechanicIdAndOrderId getOrderByMechanicIdAndOrderId;
  final AcceptOrder acceptOrder;
  final RejectOrder rejectOrder;

  final errorValidation = Rx<ErrorResponse?>(null);

  HomeController(
      {required this.getMechanicExistence,
      required this.activateMechanicStatus,
      required this.deactivateMechanicStatus,
      required this.getOrderByMechanicIdAndOrderId,
      required this.acceptOrder,
      required this.rejectOrder});

  @override
  void onInit() async {
    super.onInit();
    if (signalRService == null ||
        chatSignalRService == null ||
        locationService == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    await signalRService!.initializeConnection();
    await chatSignalRService!.initializeConnection();
    await getCurrentLocation();
    _startLocationUpdates();
    await loadMechanicStatus();

    debounce(
      signalRService!.forceRefresh,
      (value) async {
        await loadMechanicStatus();
      },
      time: const Duration(seconds: 2),
    );
  }

  Future<void> loadMechanicStatus({bool isManualClicked = false}) async {
    try {
      var data = await getMechanicExistence();

      if (data?.data == null) {
        isOnline.value = false;
        if (isManualClicked) {
          CustomToast.show(
              message:
                  "There are no ongoing orders at this time. Keep up the good work!",
              type: ToastType.info);
        }
        return;
      }

      mechanicExistence.value = data?.data == null
          ? null
          : data?.data as MechanicExistenceDataResponse;

      if (data?.data?.status.toLowerCase() == "available") {
        isOnline.value = true;

        if ((data?.data?.remainingTime ?? 0) > 0) {
          countdownTimer.value = data!.data!.remainingTime;
          isOrderPopupVisible.value = true;
          startCountdown();
          return;
        } else {
          if (isManualClicked) {
            CustomToast.show(
                message:
                    "There are no ongoing orders at this time. Keep up the good work!",
                type: ToastType.info);
          }
        }
      }

      if (data?.data?.status.toLowerCase() == "unavailable") {
        isOnline.value = false;
        if (isManualClicked) {
          CustomToast.show(
              message:
                  "There are no ongoing orders at this time. Keep up the good work!",
              type: ToastType.info);
        }
      }

      if (data?.data?.status.toLowerCase() == "bussy") {
        isOnline.value = true;

        if ((data?.data?.remainingTime ?? 0) > 0) {
          countdownTimer.value = data!.data!.remainingTime;
          isOrderPopupVisible.value = true;
          startCountdown();
          return;
        }

        if (data?.data?.orderTask != null) {
          orderData.value =
              await getOrderByMechanicIdAndOrderId(data!.data!.orderId);

          if (orderData.value?.data != null) {
            var orderStatus = orderData.value!.data.orderStatus;
            if (orderStatus == OrderStatus.mechanicAssigned ||
                orderStatus == OrderStatus.mechanicArrived ||
                orderStatus == OrderStatus.mechanicDispatched) {
              Get.toNamed(Routes.BOOKING_ACCEPTED);
            } else if (orderStatus == OrderStatus.serviceInProgress) {
              Get.toNamed(Routes.PRE_SERVICE_INSPECTION);
            }
          }
          return;
        }
      }
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, something went wrong",
          type: ToastType.error,
        );
      }
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      getCurrentLocation();
    });
  }

  Future<void> getCurrentLocation() async {
    if (locationService == null) {
      return;
    }
    try {
      var (isSuccess, errorMessage, position) =
          await locationService!.determinePosition();
      if (isSuccess && position != null) {
        final latLng = LatLng(position.latitude, position.longitude);

        initialCameraPosition.value = CameraPosition(target: latLng, zoom: 15);

        try {
          bool result = moveCameraToLocation(
              mapController: mapController, target: latLng);
          if (!result) {}
        } catch (e) {
          CustomToast.show(message: e.toString(), type: ToastType.error);
        }
      }
    } catch (_) {}
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void changeTab(int index) async {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed(Routes.REWARD);
        break;
      case 1:
        Get.toNamed(Routes.JOB_HISTORY);
        break;
      case 2:
        Get.toNamed(Routes.CHAT_CONTACT);
        break;
      case 3:
        Get.toNamed(Routes.SETTINGS);
        break;
    }
  }

  Future toggleOnlineStatus(bool value) async {
    isStatusUpdating.value = true;
    try {
      if (value) {
        var result = await activateMechanicStatus();
        if (result) {
          isOnline.value = value;
          return;
        }
        isOnline.value = !value;
      } else {
        var result = await deactivateMechanicStatus();
        if (result) {
          isOnline.value = value;
          return;
        }
        isOnline.value = !value;
      }
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, something went wrong",
          type: ToastType.error,
        );
      }
    } finally {
      isStatusUpdating.value = false;
    }
  }

  void startCountdown() {
    resetCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTimer.value > 0) {
        countdownTimer.value--;
      } else {
        timer.cancel();
        closeOrderPopup();
      }
    });
  }

  void resetCountdown() {
    _countdownTimer?.cancel();
    countdownTimer.value = 120;
  }

  void closeOrderPopup() {
    isOrderPopupVisible.value = false;
    resetCountdown();
  }

  Future<void> doAcceptOrder(String orderId) async {
    if (orderId.isEmpty) {
      return;
    }

    try {
      var result = await acceptOrder(orderId);
      if (result) {
        await loadMechanicStatus();
        closeOrderPopup();
        Get.toNamed(Routes.BOOKING_ACCEPTED);
      } else {
        CustomToast.show(
            message: 'Oops, something went wrong', type: ToastType.info);
      }
    } catch (error) {
      if (error is CustomHttpException) {
        errorValidation.value = error.errorResponse;
        if (error.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        if (error.errorResponse != null) {
          CustomToast.show(
            message: error.message,
            type: ToastType.error,
          );
          return;
        }

        CustomToast.show(message: error.message, type: ToastType.error);
        return;
      } else {
        CustomToast.show(
          message: "Oops, something went wrong",
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> doRejectOrder(String orderId) async {
    if (orderId.isEmpty) {
      return;
    }

    try {
      var result = await rejectOrder(orderId);
      if (result) {
        await loadMechanicStatus();
        closeOrderPopup();
      } else {
        CustomToast.show(
            message: 'Oops, something went wrong', type: ToastType.info);
      }
    } catch (e) {
      if (e is CustomHttpException) {
        errorValidation.value = e.errorResponse;
        if (e.statusCode == 401) {
          await logout.doLogout();
          return;
        }

        CustomToast.show(message: e.message, type: ToastType.error);
      } else {
        CustomToast.show(
            message: "Oops, something went wrong", type: ToastType.error);
      }
    }
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    _countdownTimer?.cancel();
    mapController?.dispose();
    super.onClose();
  }
}
