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
}
