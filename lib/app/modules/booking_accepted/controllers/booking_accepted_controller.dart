import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:santai_technician/app/common/widgets/custom_toast.dart';
import 'package:santai_technician/app/data/models/order/order_order_res_model.dart';
import 'package:santai_technician/app/domain/entities/order/order_order_res.dart';
import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/domain/usecases/order/arrive_order.dart';
import 'package:santai_technician/app/domain/usecases/order/cancel_order.dart';
import 'package:santai_technician/app/domain/usecases/order/dispatch_order.dart';
import 'package:santai_technician/app/exceptions/custom_http_exception.dart';
import 'package:santai_technician/app/modules/home/controllers/home_controller.dart';
import 'package:santai_technician/app/routes/app_pages.dart';
import 'package:santai_technician/app/services/location_service.dart';
import 'package:santai_technician/app/services/logout.dart';
import 'package:santai_technician/app/services/signal_r_service.dart';
import 'package:santai_technician/app/utils/camera_animator.dart';
import 'package:santai_technician/app/utils/http_error_handler.dart';

class BookingAcceptedController extends GetxController {
  final Logout logout = Logout();
  final isLoading = false.obs;
  HomeController? homeController =
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
  SignalRService? signalRService =
      Get.isRegistered<SignalRService>() ? Get.find<SignalRService>() : null;
  LocationService locationService = LocationService();

  final CancelOrder cancelOrderUseCase;
  final ArriveOrder arriveOrder;
  final DispatchOrder dispatchOrder;

  Timer? _locationUpdateTimer;
  GoogleMapController? mapController;

  // Reactive variables
  final originLatitude = 0.0.obs;
  final originLongitude = 0.0.obs;
  final destLatitude = 0.0.obs;
  final destLongitude = 0.0.obs;
  final distance = 0.0.obs; // Jarak dalam kilometer
  final estimatedTime = 0.obs; // Estimasi waktu dalam menit
  final navigationInstruction = ''.obs; // Instruksi navigasi

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAqNaUANfHojTx8EHnAD-yAbdQ8657bZz4";

  BitmapDescriptor? motorIcon; // Ikon motor

  BookingAcceptedController(
      {required this.cancelOrderUseCase,
      required this.arriveOrder,
      required this.dispatchOrder});

  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    if (signalRService == null || homeController == null) {
      Get.offAllNamed(Routes.SPLASH_SCREEN);
      return;
    }
    signalRService!.initializeConnection();
    destLatitude.value = homeController!.orderData.value?.data.latitude ?? 0.0;
    destLongitude.value =
        homeController!.orderData.value?.data.longitude ?? 0.0;
    _loadMotorIcon();
    startLocationUpdates();

    ever(homeController!.orderData, (value) {
      if (value == null) {
        Get.toNamed(Routes.HOME);
        return;
      }
      routing(value);
    });

    routing(homeController!.orderData.value);
  }

  void routing(OrderResponseModel? value) {
    if (value == null) {
      Get.toNamed(Routes.HOME);
      return;
    }
    if (value.data.orderStatus == OrderStatus.serviceInProgress) {
      Get.toNamed(Routes.PRE_SERVICE_INSPECTION);
    }
  }

  Future<void> _loadMotorIcon() async {
    motorIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/mechanic.png',
    );
  }

  @override
  void onClose() {
    stopLocationUpdates();
    mapController?.dispose();
    super.onClose();
  }

  void startLocationUpdates() {
    _locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        // Fetch current location
        var (isSuccess, errorMessage, position) =
            await locationService.determinePosition();

        if (!isSuccess || position == null) return;

        LatLng newPosition = LatLng(position.latitude, position.longitude);

        // Check if the position is off-route (e.g., more than 10 meters from the closest polyline point)
        bool isOffRoute = checkIfOffRoute(newPosition);

        if (isOffRoute) {
          // Fetch new route if off-route
          await updatePolyline();
        }

        _animateMarker('origin', newPosition);

        // Update origin coordinates
        originLatitude.value = position.latitude;
        originLongitude.value = position.longitude;

        try {
          bool result = moveCameraToLocation(
              mapController: mapController, target: newPosition);
          if (!result) {
            CustomToast.show(
                message: 'Could not focusing the camera',
                type: ToastType.warning);
          }
        } catch (e) {
          CustomToast.show(message: e.toString(), type: ToastType.error);
        }

        // Update markers
        updateMarkers();

        // Update distance, estimated time, and navigation instructions
        calculateDistanceAndTime();
        updateNavigationInstruction();
      } catch (e) {
        print("Error updating location: $e");
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> dispatchOrderAction(String orderId) async {
    try {
      if (homeController == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      bool result = await dispatchOrder(orderId);
      await homeController!.loadMechanicStatus();
      if (!result) {
        CustomToast.show(
            message:
                'Upps, error has occured during trying to update trip status',
            type: ToastType.error);
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

  Future<void> arriveOrderAction(String orderId) async {
    try {
      if (homeController == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      bool result = await arriveOrder(orderId);
      await homeController!.loadMechanicStatus();
      if (!result) {
        CustomToast.show(
            message:
                'Upps, error has occured during trying to update trip status',
            type: ToastType.error);
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

  bool checkIfOffRoute(LatLng currentPosition) {
    const double offRouteThreshold = 20.0; // 10 meters
    for (LatLng point in polylineCoordinates) {
      double distanceToPoint = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        point.latitude,
        point.longitude,
      );
      if (distanceToPoint <= offRouteThreshold) {
        return false;
      }
    }
    return true; // Off-route if no points are within the threshold
  }

  void onNextPressed() async {
    if (isLoading.value) return;
    isLoading.value = true;
    Get.toNamed(Routes.CONGRATULATION);
    isLoading.value = false;
  }

  void _animateMarker(String markerId, LatLng newPosition) {
    MarkerId id = MarkerId(markerId);
    if (markers.containsKey(id)) {
      Marker oldMarker = markers[id]!;
      LatLng oldPosition = oldMarker.position;

      double deltaLat = newPosition.latitude - oldPosition.latitude;
      double deltaLng = newPosition.longitude - oldPosition.longitude;
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        double step = timer.tick / 20.0; // Total 1 second for transition
        if (step >= 1.0) {
          timer.cancel();
          markers[id] = oldMarker.copyWith(positionParam: newPosition);
          update();
        } else {
          LatLng intermediatePosition = LatLng(
            oldPosition.latitude + (deltaLat * step),
            oldPosition.longitude + (deltaLng * step),
          );
          markers[id] = oldMarker.copyWith(positionParam: intermediatePosition);
          update();
        }
      });
    } else {
      markers[id] = Marker(
        markerId: id,
        position: newPosition,
        icon: motorIcon ?? BitmapDescriptor.defaultMarker,
      );
      update();
    }
  }

  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  void updateMarkers() {
    // Update origin marker
    markers[const MarkerId("origin")] = Marker(
      markerId: const MarkerId("origin"),
      position: LatLng(originLatitude.value, originLongitude.value),
      icon: motorIcon ?? BitmapDescriptor.defaultMarker,
    );

    // Ensure destination marker exists
    markers[const MarkerId("destination")] = Marker(
      markerId: const MarkerId("destination"),
      position: LatLng(destLatitude.value, destLongitude.value),
      icon: BitmapDescriptor.defaultMarkerWithHue(90),
    );

    update();
  }

  Future<void> updatePolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleAPiKey,
        request: PolylineRequest(
          origin: PointLatLng(originLatitude.value, originLongitude.value),
          destination: PointLatLng(destLatitude.value, destLongitude.value),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        // Update polyline
        polylines[const PolylineId("route")] = Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue, // Warna garis (misalnya, biru)
          width: 5, // Ketebalan garis
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10)
          ], // Pola garis putus-putus
          jointType: JointType.round, // Sambungan melengkung
          points: polylineCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap, zIndex: 1, consumeTapEvents: true,
          onTap: () {},
        );

        update(); // Notify UI
      }
    } catch (_) {}
  }

  void calculateDistanceAndTime() {
    if (polylineCoordinates.isNotEmpty) {
      // Calculate total distance from current location to destination
      double totalDistance = 0.0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += Geolocator.distanceBetween(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      distance.value = totalDistance / 1000; // Convert to kilometers

      // Estimate time (assuming average speed of 30 km/h)
      estimatedTime.value = (distance.value / 0.5).round();
    }
  }

  void updateNavigationInstruction() {
    if (polylineCoordinates.length < 2) {
      navigationInstruction.value = "You have arrived at your destination.";
      return;
    }

    // Calculate distance to the next waypoint
    double distanceToNextPoint = Geolocator.distanceBetween(
      originLatitude.value,
      originLongitude.value,
      polylineCoordinates[1].latitude,
      polylineCoordinates[1].longitude,
    );

    if (distanceToNextPoint <= 5.0) {
      // Move to the next waypoint
      polylineCoordinates.removeAt(0);

      // Generate new instruction
      navigationInstruction.value = "5 meters ahead, turn right!";
    } else {
      navigationInstruction.value =
          "${distanceToNextPoint.toStringAsFixed(1)} meters ahead, continue straight.";
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    try {
      bool result = moveCameraToLocation(
          mapController: controller,
          target: LatLng(originLatitude.value, originLongitude.value));
      if (!result) {
        CustomToast.show(
            message: 'Could not focusing the camera', type: ToastType.warning);
      }
    } catch (e) {
      CustomToast.show(message: e.toString(), type: ToastType.error);
    }
  }

  void showConfirmDialog({required String title, required String content}) {
    Get.defaultDialog(
      title: title,
      middleText: content,
      textCancel: "No",
      textConfirm: "Cancel",
      cancelTextColor: Colors.black,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onCancel: () {},
      onConfirm: () async {
        Get.back();
        await cancelOrder();
      },
    );
  }

  Future<void> cancelOrder() async {
    try {
      if (homeController == null) {
        Get.offAllNamed(Routes.SPLASH_SCREEN);
        return;
      }
      String? orderId = homeController!.orderData.value?.data.orderId;
      if (orderId == null || orderId.isEmpty) return;

      bool result = await cancelOrderUseCase(orderId);
      if (result) {
        Get.offAllNamed(Routes.HOME);
        CustomToast.show(
          message: 'Order was successfully cancelled',
          type: ToastType.success,
        );
      } else {
        CustomToast.show(
          message: 'Cannot cancel the order',
          type: ToastType.error,
        );
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

  void openChat(OrderResponseData? order) {
    if (order == null || order.mechanic == null) {
      return;
    }

    Get.toNamed(Routes.CHAT_CONVERSATION, arguments: {
      'orderId': order.orderId,
      'buyerId': order.buyer.buyerId,
      'buyerName': order.buyer.buyerName,
      'buyerImageUrl': order.buyer.buyerImageUrl,
      'mechanicId': order.mechanic!.mechanicId,
      'mechanicName': order.mechanic!.name,
      'mechanicImageUrl': order.mechanic!.imageUrl
    });
  }
}
