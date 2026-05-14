import 'package:watt/data/models/user_model.dart';

class ProfileState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final UserModel? userData;
  final String? name;
  final String? email;
  final bool? isEmailVerified;
  final String? phoneNumber;
  final String? errorMessage;
  final String? nameError;
  final String? emailError;
  final String? phoneNumberError;
  final String? newEmailValue;
  final String? passwordError;

  ProfileState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.userData,
    this.name,
    this.email,
    this.isEmailVerified,
    this.phoneNumber,
    this.errorMessage,
    this.nameError,
    this.emailError,
    this.phoneNumberError,
    this.newEmailValue,
    this.passwordError,
  });

  ProfileState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    UserModel? userData,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? phoneNumber,
    String? Function()? errorMessage,
    bool clearUserData = false,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? phoneNumberError,
    String? Function()? newEmailValue,
    String? Function()? passwordError,
  }) {
    return ProfileState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      userData: clearUserData ? null : (userData ?? this.userData),
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      nameError: nameError != null ? nameError() : this.nameError,
      emailError: emailError != null ? emailError() : this.emailError,
      phoneNumberError: phoneNumberError != null
          ? phoneNumberError()
          : this.phoneNumberError,
      newEmailValue: newEmailValue != null
          ? newEmailValue()
          : this.newEmailValue,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
    );
  }
}
