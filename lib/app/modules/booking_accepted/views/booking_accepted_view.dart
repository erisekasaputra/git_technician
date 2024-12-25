import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santai_technician/app/domain/enumerations/order_status.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import 'package:santai_technician/app/utils/order_id_parser.dart';
import '../controllers/booking_accepted_controller.dart';

class BookingAcceptedView extends GetView<BookingAcceptedController> {
  const BookingAcceptedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Obx(
                () {
                  // Tampilkan Google Map atau Progress Bar berdasarkan loading state
                  if (controller.isLoading.value) {
                    return _buildProgressBar(); // Progress bar saat loading
                  } else {
                    return Stack(
                      children: [
                        _buildMap(), // Google Map
                        _buildRouteInfo(context), // Informasi rute di atas
                        _buildBottomInfo(context), // Informasi di bagian bawah
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildMap() {
    return Obx(() => GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(controller.originLatitude.value,
                  controller.originLongitude.value),
              zoom: 15),
          myLocationEnabled: false,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: controller.onMapCreated,
          markers: Set<Marker>.of(controller.markers.values),
          polylines: Set<Polyline>.of(controller.polylines.values),
          style: '''[
                        {
                          "elementType": "geometry",
                          "stylers": [{"color": "#e0e0e0"}] // Abu-abu terang untuk area umum
                        },
                        {
                          "elementType": "labels.text.fill",
                          "stylers": [{"color": "#4a4a4a"}] // Abu-abu gelap untuk teks
                        },
                        {
                          "elementType": "labels.text.stroke",
                          "stylers": [{"color": "#ffffff"}] // Putih untuk latar belakang teks
                        },
                        {
                          "featureType": "water",
                          "elementType": "geometry",
                          "stylers": [{"color": "#a2c9ff"}] // Biru muda untuk air
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry",
                          "stylers": [{"color": "#d6d6d6"}] // Abu-abu terang untuk jalan
                        },
                        {
                          "featureType": "road",
                          "elementType": "geometry.stroke",
                          "stylers": [{"color": "#a0a0a0"}] // Abu-abu gelap untuk tepi jalan
                        },
                        {
                          "featureType": "road",
                          "elementType": "labels",
                          "stylers": [{"visibility": "on"}] // Sembunyikan label jalan
                        },
                        {
                          "featureType": "poi",
                          "elementType": "geometry",
                          "stylers": [{"color": "#daf4ff"}] // Abu-abu untuk area tempat menarik (POI)
                        },
                        {
                          "featureType": "landscape.man_made",
                          "elementType": "geometry",
                          "stylers": [{"color": "#e8e8e8"}] // Abu-abu terang untuk lanskap buatan
                        },
                        {
                          "featureType": "administrative",
                          "elementType": "labels",
                          "stylers": [{"visibility": "off"}] // Sembunyikan label administratif
                        }                     
                    ]''',
          // initialCameraPosition: controller.initialCameraPosition.value,
          // onMapCreated: controller.onMapCreated,
          // polylines: controller.polylines.value,
          // myLocationEnabled: true,
          // myLocationButtonEnabled: false,
          // zoomControlsEnabled: false,
          // mapType: MapType.terrain,
          // tiltGesturesEnabled: true,
          // compassEnabled: true,
          // rotateGesturesEnabled: true,
          // scrollGesturesEnabled: true,
          // markers: Set<Marker>.from(controller.markers.value),
          // onCameraMove: controller.onCameraMove,
        ));
  }

  Widget _buildBottomInfo(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary;

    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: Center(
        child: IntrinsicWidth(
          // Ensure the width matches the largest child
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust height to fit content
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align children
              children: [
                _buildOrderInfo(),
                const SizedBox(height: 15),
                _buildActionButtons(primary_300),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order ID: #${OrderIdParser.parse(controller.homeController?.orderData.value?.data.orderId.toUpperCase() ?? '')}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Color primary_300) {
    return Obx(() {
      IconData actionIcon = Icons.play_arrow;
      String actionText = "Start Trip";
      if (controller.homeController?.orderData.value == null) {
        return const SizedBox.shrink();
      }
      var orderData = controller.homeController?.orderData.value?.data;
      var status = controller.homeController?.orderData.value?.data.orderStatus;
      if (status == OrderStatus.mechanicAssigned) {
        actionIcon = Icons.play_arrow;
        actionText = "Start Trip";
      } else if (status == OrderStatus.mechanicDispatched) {
        actionIcon = Icons.flag;
        actionText = "End Trip";
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (status == OrderStatus.mechanicAssigned ||
              status == OrderStatus.mechanicDispatched) ...[
            _buildActionButton(actionIcon, actionText, primary_300, () async {
              if (status == OrderStatus.mechanicAssigned) {
                await controller.dispatchOrderAction(orderData?.orderId ?? '');
              }

              if (status == OrderStatus.mechanicDispatched) {
                await controller.arriveOrderAction(orderData?.orderId ?? '');
              }
            })
          ],
          if (status == OrderStatus.mechanicArrived) ...[
            const SizedBox(width: 15),
            _buildActionButton(Icons.qr_code, 'Scan', primary_300, () {
              controller.onNextPressed();
            })
          ],
          const SizedBox(width: 15),
          _buildActionButton(Icons.message, 'Chat', primary_300, () {
            controller.openChat(orderData);
          }),
          const SizedBox(width: 15),
          _buildActionButton(Icons.cancel_sharp, 'Cancel', Colors.red, () {
            controller.showConfirmDialog(
                title: 'Cancel Order',
                content:
                    'Are you certain you wish to cancel your order? Let us know how we can assist you further!');
          }),
          const SizedBox(width: 15),
        ],
      );
    });
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primary_300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.turn_left,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              const SizedBox(width: 12),
              Obx(
                () => controller.navigationInstruction.value.isEmpty
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Route',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Obx(() => Text(
                                  controller.navigationInstruction.value.isEmpty
                                      ? ''
                                      : controller.navigationInstruction.value,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                )),
                            Text(
                                'Arrive at ${controller.estimatedTime} minutes',
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
