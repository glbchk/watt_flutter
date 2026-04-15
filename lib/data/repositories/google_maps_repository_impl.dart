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
  Future<bool> getLocationPermission() async {
    return await googleMapsRemoteDataSource.getLocationPermission();
  }

  @override
  Future<Position?> goToMyLocation() async {
    return await googleMapsRemoteDataSource.goToMyLocation();
  }

  @override
  Future<LocationResult?> searchLocation(
    String address,
    GoogleMapController? mapController,
  ) async {
    return await googleMapsRemoteDataSource.searchLocation(
      address: address,
      mapController: mapController,
    );
  }

  @override
  Future<String?> handleMapTap(LatLng tappedPoint) async {
    return await googleMapsRemoteDataSource.handleMapTap(
      tappedPoint: tappedPoint,
    );
  }

  @override
  Future<LocationResult?> chooseLocationOnMap() async {
    return await googleMapsRemoteDataSource.chooseLocationOnMap();
  }

  @override
  Future<double?> getDistanceTo({
    required Position? myLocation,
    required double targetLatitude,
    required double targetLongitude,
  }) async {
    return await googleMapsRemoteDataSource.getDistanceTo(
      myLocation: myLocation,
      targetLatitude: targetLatitude,
      targetLongitude: targetLongitude,
    );
  }
}
