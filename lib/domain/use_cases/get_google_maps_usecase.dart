import 'package:watt/data/repositories/google_maps_repository_impl.dart';

abstract class GoogleMapsUseCase {
  final GoogleMapsRepositoryImpl googleMapsRepository =
      GoogleMapsRepositoryImpl();
}

class FetchLocationSuggestionsUseCase extends GoogleMapsUseCase {
  Future<List<String>> execute(String input) {
    return googleMapsRepository.fetchSuggestions(input);
  }
}
