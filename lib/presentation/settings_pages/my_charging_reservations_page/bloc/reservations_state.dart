import 'package:watt/data/models/user_model.dart';

class ReservationsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final bool? isLocationEnabled;
  final UserModel? userData;
  final String? errorMessage;
  final String? nameError;
  final String? emailError;
  final String? phoneNumberError;
  final String? newEmailValue;
  final String? passwordError;

  ReservationsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.isLocationEnabled,
    this.userData,
    this.errorMessage,
    this.nameError,
    this.emailError,
    this.phoneNumberError,
    this.newEmailValue,
    this.passwordError,
  });

  ReservationsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    bool? isLocationEnabled,
    UserModel? userData,
    String? Function()? errorMessage,
    bool clearUserData = false,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? phoneNumberError,
    String? Function()? newEmailValue,
    String? Function()? passwordError,
  }) {
    return ReservationsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      userData: clearUserData ? null : (userData ?? this.userData),
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
