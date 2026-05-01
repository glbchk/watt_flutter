import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/models/charging_station_model.dart';

class GoogleMapsHelperMethods {
  static double getMarkerHue({
    required String stationId,
    required Set<String> userIds,
    required ChargingStationType type,
  }) {
    print(userIds);
    if (type == ChargingStationType.public) {
      return BitmapDescriptor.hueGreen;
    }

    if (userIds.contains(stationId)) {
      return BitmapDescriptor.hueRed;
    }

    return BitmapDescriptor.hueAzure;
  }

  static Future<String> convertPositionToAddress(Position? position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position?.latitude ?? 0.0,
        position?.longitude ?? 0.0,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}";
      }

      return "Address not found";
    } catch (e) {
      return "Error fetching address";
    }
  }

  static Future<Position?> convertAddressToPosition(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location loc = locations.first;

        return Position(
          latitude: loc.latitude,
          longitude: loc.longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }

      return null;
    } catch (e) {
      print("Error converting address to position: $e");
      return null;
    }
  }

  // static Future<String?> handleMapTap({
  //   required LatLng tappedPoint,
  // }) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       tappedPoint.latitude,
  //       tappedPoint.longitude,
  //     );
  //
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       return "${place.street}, ${place.locality}";
  //     }
  //   } catch (e) {
  //     print("Could not find address for this point: $e");
  //   }
  //   return null;
  // }
  //
  // static Future<Position?> goToMyLocation({
  //   GoogleMapController? controller,
  // }) async {
  //   if (controller == null) {
  //     print("Map controller is null");
  //     return null;
  //   }
  //
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return null;
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return null;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     await Geolocator.openAppSettings();
  //     return null;
  //   }
  //
  //   const LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //   );
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //     locationSettings: locationSettings,
  //   );
  //
  //   controller.animateCamera(
  //     CameraUpdate.newLatLngZoom(
  //       LatLng(position.latitude, position.longitude),
  //       15,
  //     ),
  //   );
  //   return position;
  // }
  //
  // static Future<void> searchLocation({
  //   required String address,
  //   required GoogleMapController? mapController,
  //   required Function(LatLng location, String formattedAddress) onLocationFound,
  // }) async {
  //   if (address.isEmpty) return;
  //
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //
  //     if (locations.isNotEmpty) {
  //       Location result = locations.first;
  //       LatLng targetLatLng = LatLng(result.latitude, result.longitude);
  //
  //       List<Placemark> placemarks = await placemarkFromCoordinates(
  //         result.latitude,
  //         result.longitude,
  //       );
  //
  //       String cleanAddress = address;
  //       if (placemarks.isNotEmpty) {
  //         final p = placemarks.first;
  //         cleanAddress = "${p.street}, ${p.locality}";
  //       }
  //
  //       mapController?.animateCamera(
  //         CameraUpdate.newLatLngZoom(targetLatLng, 15),
  //       );
  //
  //       onLocationFound(targetLatLng, cleanAddress);
  //
  //       mapController?.showMarkerInfoWindow(const MarkerId('selected_point'));
  //     }
  //   } catch (e) {
  //     print("Error finding location: $e");
  //     // You could trigger a SnackBar here if the address is invalid
  //   }
  // }

  // static Future<void> extractMyCityLocation({
  //   GoogleMapController? mapController,
  //   required Function(LatLng location, String formattedAddress) onLocationFound,
  // }) async {
  //   final position = await goToMyLocation(controller: mapController);
  //
  //   if (position == null) return;
  //
  //   final latLng = LatLng(position.latitude, position.longitude);
  //
  //   final placemarks = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //
  //   String formattedAddress = "";
  //
  //   if (placemarks.isNotEmpty) {
  //     final place = placemarks.first;
  //
  //     final city = place.locality ?? "";
  //     final country = place.country ?? "";
  //
  //     formattedAddress = "$city, $country";
  //   }
  //
  //   mapController?.animateCamera(
  //     CameraUpdate.newLatLngZoom(latLng, 12),
  //   );
  //
  //   onLocationFound(latLng, formattedAddress);
  //
  //   mapController?.showMarkerInfoWindow(
  //     const MarkerId('selected_point'),
  //   );
  // }
}
