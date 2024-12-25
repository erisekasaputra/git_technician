import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService extends GetxService {
  final address = 'Fetching location...'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<
      (
        double latitude,
        double longitude,
        bool isSuccess,
        String? errorMessage
      )> getCurrentLocation() async {
    isLoading.value = true;
    try {
      var (bool isSuccess, String? errorMessage, Position? position) =
          await determinePosition();
      if (isSuccess && position != null) {
        return (position.latitude, position.longitude, isSuccess, null);
      }
      return (0.0, 0.0, false, errorMessage);
    } catch (e) {
      return (0.0, 0.0, false, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<(String? data, bool isSuccess)> translateCoordinatesToAddress(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String street = '';
        if (place.street != null) {
          if (place.street!.toLowerCase().contains('route') ||
              place.street!.toLowerCase().contains('street_address') ||
              place.street!.toLowerCase().contains('street') ||
              place.street!.toLowerCase().contains('jl')) {}
          street = '${place.street}, ';
        }

        return (
          "$street${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}",
          true
        );
      } else {
        return (null, false);
      }
    } catch (e) {
      return (null, false);
    }
  }

  Future<(bool isSuccess, String? errorMessage, Position? position)>
      determinePosition() async {
    try {
      // Cek apakah layanan lokasi diaktifkan
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return (
            false,
            "Location services are still disabled. Please enable them in settings.",
            null
          );
        }
      }

      // Cek izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Jika izin ditolak, minta kembali
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return (
            false,
            "Location permission denied. Please allow access to location.",
            null
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return (
          false,
          "Location permission permanently denied. Please enable it in settings.",
          null
        );
      }

      // Mendapatkan posisi lokasi dengan akurasi tinggi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit:
            const Duration(seconds: 5), // Batasi waktu pengambilan posisi
      );

      return (true, null, position);
    } on TimeoutException {
      return (
        false,
        "The request to get location timed out. Please try again.",
        null
      );
    } on PermissionDeniedException {
      openAppSettings();
      return (false, "Permission denied to access location services.", null);
    } catch (e) {
      return (false, "An unexpected error occurred: $e", null);
    }
  }

  // Future<void> getCurrentLocation() async {
  //   isLoading.value = true;
  //   try {
  //     Map<String, dynamic> dataResponse = await determinePosition();
  //     if (!dataResponse["error"]) {
  //       Position position = dataResponse["position"];
  //       try {
  //         List<Placemark> placemarks = await placemarkFromCoordinates(
  //           position.latitude,
  //           position.longitude,
  //         ).timeout(Duration(seconds: 20));
  //         if (placemarks.isNotEmpty) {
  //           String currentAddress = "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].country}";
  //           address.value = currentAddress;
  //         } else {
  //           address.value = "Location found, but address details are unavailable";
  //         }
  //       } catch (e) {
  //         print("Error in placemarkFromCoordinates: $e");
  //         address.value = "Error getting address details";
  //       }
  //     } else {
  //       Get.snackbar("Error", dataResponse["message"]);
  //     }
  //   } catch (e) {
  //     print("Error in getCurrentLocation: $e");
  //     Get.snackbar("Error", "Failed to get location. Please try again.");
  //     address.value = "Location unavailable";
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
