// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(child: _buildMap()),
//           _buildBottomNavBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset('assets/images/santai_logo.png', height: 40),
//           Obx(() => Switch(
//             value: controller.isOnline.value,
//             onChanged: controller.toggleOnlineStatus,
//             activeColor: Colors.green,
//           )),
//         ],
//       ),
//     );
//   }

//   Widget _buildMap() {
//     return Obx(() => GoogleMap(
//       initialCameraPosition: controller.initialCameraPosition,
//       onMapCreated: controller.onMapCreated,
//       myLocationEnabled: true,
//       myLocationButtonEnabled: false,
//       zoomControlsEnabled: false,
//       markers: controller.markers.value,
//     ));
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.emoji_events, 'Reward'),
//           _buildNavItem(Icons.history, 'Job History'),
//           _buildNavItem(Icons.notifications, 'Notification'),
//           _buildNavItem(Icons.help, 'Support'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: Colors.blue),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.blue)),
//       ],
//     );
//   }
// }