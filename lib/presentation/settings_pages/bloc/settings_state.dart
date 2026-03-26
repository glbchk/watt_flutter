import 'package:geolocator/geolocator.dart';

class SettingsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final String? address;
  final Position? addressPosition;
  final List<String>? locationSuggestions;
  final String? errorMessage;

  SettingsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.address,
    this.addressPosition,
    this.locationSuggestions,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    String? address,
    Position? addressPosition,
    List<String>? locationSuggestions,
    String? errorMessage,
  }) {
    return SettingsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      address: address ?? this.address,
      addressPosition: addressPosition ?? this.addressPosition,
      locationSuggestions: locationSuggestions ?? this.locationSuggestions,
      errorMessage: errorMessage,
    );
  }
}
