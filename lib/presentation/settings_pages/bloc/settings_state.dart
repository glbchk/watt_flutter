import 'package:watt/data/models/user_model.dart';

class SettingsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final UserModel? userData;
  final String? errorMessage;

  SettingsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.userData,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    UserModel? userData,
    String? errorMessage,
    bool clearUserData = false,
  }) {
    return SettingsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      userData: clearUserData ? null : (userData ?? this.userData),
      errorMessage: errorMessage,
    );
  }
}
