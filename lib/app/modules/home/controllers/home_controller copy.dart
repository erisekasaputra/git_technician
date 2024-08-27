import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  final isOnline = false.obs;
  final initialCameraPosition = const CameraPosition(
    target: LatLng(3.1390, 101.6869), // Kuala Lumpur coordinates
    zoom: 12,
  );

  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  late GoogleMapController mapController;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  void toggleOnlineStatus(bool value) {
    isOnline.value = value;
    // Here you can add logic to handle the online/offline status
    // For example, update the user's status on the server
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      
      mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
      
      markers.value = {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      };
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}