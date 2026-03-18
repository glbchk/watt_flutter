import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';

abstract class GoogleMapsRepository {
  Future<List<String>> fetchSuggestions(String input);
  Future<Position?> goToMyLocation();
  Future<LocationResult?> searchLocation(
    String address,
    GoogleMapController? mapController,
    // Function(LatLng location, String formattedAddress) onLocationFound,
  );
}
