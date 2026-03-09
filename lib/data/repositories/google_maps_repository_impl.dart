import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/domain/repositories/google_maps_repository.dart';

class GoogleMapsRepositoryImpl implements GoogleMapsRepository {
  final GoogleMapsRemoteDataSource googleMapsRemoteDataSource =
      GoogleMapsRemoteDataSource();

  @override
  Future<List<String>> fetchSuggestions(String input) async {
    return await googleMapsRemoteDataSource.fetchSuggestions(input);
  }
}
