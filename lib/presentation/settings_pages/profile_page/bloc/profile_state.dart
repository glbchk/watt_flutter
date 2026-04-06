import 'package:watt/data/models/user_model.dart';

class ProfileState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final UserModel? userData;
  final String? errorMessage;

  ProfileState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.userData,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    UserModel? userData,
    String? errorMessage,
    bool clearUserData = false,
  }) {
    return ProfileState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      userData: clearUserData ? null : (userData ?? this.userData),
      errorMessage: errorMessage,
    );
  }
}
