import 'package:watt/data/models/user_model.dart';

class ProfileState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final UserModel? userData;
  final String? errorMessage;
  final String? nameError;
  final String? emailError;
  final String? phoneNumberError;
  final String? newEmailValue;
  final String? newEmailValueError;
  final String? passwordError;

  ProfileState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.userData,
    this.errorMessage,
    this.nameError,
    this.emailError,
    this.phoneNumberError,
    this.newEmailValue,
    this.newEmailValueError,
    this.passwordError,
  });

  ProfileState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    UserModel? userData,
    String? errorMessage,
    bool clearUserData = false,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? phoneNumberError,
    String? Function()? newEmailValue,
    String? Function()? newEmailValueError,
    String? Function()? passwordError,
  }) {
    return ProfileState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      userData: clearUserData ? null : (userData ?? this.userData),
      errorMessage: errorMessage,
      nameError: nameError != null ? nameError() : this.nameError,
      emailError: emailError != null ? emailError() : this.emailError,
      phoneNumberError: phoneNumberError != null
          ? phoneNumberError()
          : this.phoneNumberError,
      newEmailValue: newEmailValue != null
          ? newEmailValue()
          : this.newEmailValue,
      newEmailValueError: newEmailValueError != null
          ? newEmailValueError()
          : this.newEmailValueError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
    );
  }
}
