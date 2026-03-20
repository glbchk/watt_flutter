import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/data/repositories/google_maps_repository_impl.dart';

abstract class GoogleMapsUseCase {
  final GoogleMapsRepositoryImpl googleMapsRepository =
      GoogleMapsRepositoryImpl();
}

class GoToMyLocationUseCase extends GoogleMapsUseCase {
  Future<Position?> execute() {
    return googleMapsRepository.goToMyLocation();
  }
}

class SearchLocationUseCase extends GoogleMapsUseCase {
  Future<LocationResult?> execute(
    String address,
    GoogleMapController? mapController,
  ) {
    return googleMapsRepository.searchLocation(
      address,
      mapController,
    );
  }
}

class HandleMapTapUseCase extends GoogleMapsUseCase {
  Future<String?> execute(LatLng tappedPoint) {
    return googleMapsRepository.handleMapTap(tappedPoint);
  }
}

class ChooseLocationOnMapUseCase extends GoogleMapsUseCase {
  Future<LocationResult?> execute() {
    return googleMapsRepository.chooseLocationOnMap();
  }
}

class FetchLocationSuggestionsUseCase extends GoogleMapsUseCase {
  Future<List<String>> execute(String input) {
    return googleMapsRepository.fetchSuggestions(input);
  }
}
