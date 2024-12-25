import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santai_technician/app/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    final Color alert_300 = Theme.of(context).colorScheme.alert_300;
    final Color success_300 = Theme.of(context).colorScheme.success_300;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMainContent(context)),
                _buildBottomNavBar(context),
              ],
            ),
          ),
          Obx(() => Visibility(
                visible: controller.isOrderPopupVisible.value,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'New Order!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primary_300),
                        ),
                        const Text('You have a new order request.'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await controller.doAcceptOrder(controller
                                        .mechanicExistence.value?.orderId ??
                                    '');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: success_300,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Accept',
                                      style: TextStyle(color: Colors.white)),
                                  Obx(() => Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                            '${controller.countdownTimer.value}s',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      )),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await controller.doRejectOrder(controller
                                        .mechanicExistence.value?.orderId ??
                                    '');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: alert_300,
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              Obx(() => Text(
                    controller.isStatusUpdating.value
                        ? (controller.isOnline.value
                            ? "Turning off"
                            : "Turning on")
                        : (!controller.isOnline.value ? "Offline" : "Online"),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  )),
              Obx(() => Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: controller.isOnline.value,
                      onChanged: controller.isStatusUpdating.value
                          ? null
                          : controller.toggleOnlineStatus,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey[300],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;
    return Obx(() => controller.initialCameraPosition.value == null
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: controller.initialCameraPosition.value!,
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                style: '''[
                        {
                          "elementType": "geometry",
                          "stylers": [{"color": "#f0f0f0"}] // Abu-abu terang untuk area umum
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
                          "stylers": [{"color": "#ffffff"}] // Abu-abu terang untuk jalan
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
                          "stylers": [{"color": "#f0f0f0"}] // Abu-abu untuk area tempat menarik (POI)
                        },
                        {
                          "featureType": "landscape.man_made",
                          "elementType": "geometry",
                          "stylers": [{"color": "#f0f0f0"}] // Abu-abu terang untuk lanskap buatan
                        },
                        {
                          "featureType": "administrative",
                          "elementType": "labels",
                          "stylers": [{"visibility": "off"}] // Sembunyikan label administratif
                        }                     
                    ]''',
              ),
              Obx(
                () => controller.orderData.value == null
                    ? const SizedBox.shrink()
                    : Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () {},
                          backgroundColor:
                              primary_300, // Warna ikon berbeda dari latar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Membuat sudut lebih tumpul
                          ),
                          elevation: 8, // Menambahkan efek bayangan
                          splashColor: Colors
                              .blue.shade100, // Warna efek saat tombol ditekan
                          highlightElevation: 12,
                          child: const Icon(Icons.delivery_dining,
                              size: 35,
                              color: Colors
                                  .white), // Elevasi lebih tinggi saat ditekan
                        ),
                      ),
              ),
            ],
          ));
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              Image(
                image: Image.asset('assets/icons/reward-icon.png').image,
              ),
              'Reward',
              0,
              primary_300),
          _buildNavItem(
              Image(
                image: Image.asset('assets/icons/history-icon.png').image,
              ),
              'History',
              1,
              primary_300),
          _buildNavItem(
              Image(
                image: Image.asset('assets/icons/bell-icon.png').image,
              ),
              'Inbox',
              2,
              primary_300),
          _buildNavItem(
              Image(
                image: Image.asset('assets/icons/menu.png').image,
              ),
              'Settings',
              3,
              primary_300),
          // _buildNavItem(Icons.history, 'Job History', 1, primary_300),
          // _buildNavItem(Icons.work, 'Job', 2, primary_300, isLarger: true),
          // _buildNavItem(Icons.notifications, 'Notification', 3, primary_300),
          // _buildNavItem(Icons.menu, 'Settings', 4, primary_300),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      Widget icon, String label, int index, Color primary_300) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: icon,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primary_300,
            ),
          ),
        ],
      ),
    );
  }
}
