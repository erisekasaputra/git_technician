import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService extends GetxService {
  final address = 'Fetching location...'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> dataResponse = await determinePosition();
      if (!dataResponse["error"]) {
        Position position = dataResponse["position"];
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(Duration(seconds: 20));
          if (placemarks.isNotEmpty) {
            String currentAddress = "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].country}";
            address.value = currentAddress;
          } else {
            address.value = "Location found, but address details are unavailable";
          }
        } catch (e) {
          print("Error in placemarkFromCoordinates: $e");
          address.value = "Error getting address details";
        }
      } else {
        Get.snackbar("Error", dataResponse["message"]);
      }
    } catch (e) {
      print("Error in getCurrentLocation: $e");
      Get.snackbar("Error", "Failed to get location. Please try again.");
      address.value = "Location unavailable";
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {"error": true, "message": "Layanan lokasi dinonaktifkan."};
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {"error": true, "message": "Izin lokasi ditolak."};
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return {"error": true, "message": "Izin lokasi ditolak secara permanen."};
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      return {"error": false, "position": position};
    } catch (e) {
      print("Error in determinePosition: $e");
      return {"error": true, "message": "Gagal mendapatkan posisi: $e"};
    }
  }
}