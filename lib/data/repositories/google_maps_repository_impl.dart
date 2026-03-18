import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/domain/repositories/google_maps_repository.dart';

class GoogleMapsRepositoryImpl implements GoogleMapsRepository {
  final GoogleMapsRemoteDataSource googleMapsRemoteDataSource =
      GoogleMapsRemoteDataSource();

  @override
  Future<List<String>> fetchSuggestions(String input) async {
    return await googleMapsRemoteDataSource.fetchSuggestions(input);
  }

  @override
  Future<Position?> goToMyLocation() async {
    return await googleMapsRemoteDataSource.goToMyLocation();
  }

  @override
  Future<LocationResult?> searchLocation(
    String address,
    GoogleMapController? mapController,
    // Function(LatLng location, String formattedAddress) onLocationFound,
  ) async {
    return await googleMapsRemoteDataSource.searchLocation(
      address: address,
      mapController: mapController,
      // onLocationFound: onLocationFound,
    );
  }
}
