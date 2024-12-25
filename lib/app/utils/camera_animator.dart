import 'package:google_maps_flutter/google_maps_flutter.dart';

bool moveCameraToLocation({
  required GoogleMapController? mapController,
  required LatLng target,
  double zoom = 15.0,
}) {
  try {
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: zoom,
          ),
        ),
      );
      return true;
    }
    return true;
  } catch (_) {
    return false;
  }
}
