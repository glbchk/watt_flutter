import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';

abstract class GoogleMapsRepository {
  Future<List<String>> fetchSuggestions(String input);
  Future<bool> getLocationPermission();
  Future<Position?> goToMyLocation();
  Future<LocationResult?> searchLocation(
    String address,
    GoogleMapController? mapController,
  );
  Future<String?> handleMapTap(LatLng tappedPoint);
  Future<LocationResult?> chooseLocationOnMap();
  Future<double?> getDistanceTo({
    required Position? myLocation,
    required double targetLatitude,
    required double targetLongitude,
  });
}
