import 'package:watt/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class FirstTimeAuthState extends AuthState {}

class SignInAnonymouslyState extends AuthState {}

// default state for page
class AuthUnauthenticatedState extends AuthState {
  final bool isRegisterMode;
  final bool isLoading;
  final String? errorMessage;

  final String? emailError;
  // final bool isEmailValid;
  final String? passwordError;
  // final bool isPasswordValid;
  final String? retypePasswordError;
  // final bool isRetypePasswordValid;
  final String? forgotPasswordError;
  // final bool isForgotPasswordValid;

  AuthUnauthenticatedState({
    required this.isRegisterMode,
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    // this.isEmailValid = false,
    this.passwordError,
    // this.isPasswordValid = false,
    this.retypePasswordError,
    // this.isRetypePasswordValid = false,
    this.forgotPasswordError,
    // this.isForgotPasswordValid = false,
  });

  AuthUnauthenticatedState copyWith({
    bool? isRegisterMode,
    bool? isLoading,
    String? Function()? errorMessage,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? retypePasswordError,
    String? Function()? forgotPasswordError,
  }) {
    return AuthUnauthenticatedState(
      isRegisterMode: isRegisterMode ?? this.isRegisterMode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
      retypePasswordError: retypePasswordError != null
          ? retypePasswordError()
          : this.retypePasswordError,
      forgotPasswordError: forgotPasswordError != null
          ? forgotPasswordError()
          : this.forgotPasswordError,
    );
  }
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}

class AuthInProgressState extends AuthState {
  final UserModel userDraft;
  final String password;
  AuthInProgressState(this.userDraft, this.password);
}

// class TextFieldsValidState extends AuthState {
//   final String? emailError;
//   final bool? isEmailValid;
//   final String? passwordError;
//   final bool? isPasswordValid;
//   final String? retypePasswordError;
//   final bool? isRetypePasswordValid;
//
//   TextFieldsValidState(
//     this.emailError,
//     this.isEmailValid,
//     this.passwordError,
//     this.isPasswordValid,
//     this.retypePasswordError,
//     this.isRetypePasswordValid,
//   );
//
//   TextFieldsValidState copyWith({
//     String? Function()? emailError,
//     bool? Function()? isEmailValid,
//     String? Function()? passwordError,
//     bool? Function()? isPasswordValid,
//     String? Function()? retypePasswordError,
//     bool? Function()? isRetypePasswordValid,
//   }) {
//     return TextFieldsValidState(
//       emailError != null ? emailError() : this.emailError,
//       isEmailValid != null ? isEmailValid() : this.isEmailValid,
//       passwordError != null ? passwordError() : this.passwordError,
//       isPasswordValid != null ? isPasswordValid() : this.isPasswordValid,
//       retypePasswordError != null
//           ? retypePasswordError()
//           : this.retypePasswordError,
//       isRetypePasswordValid != null
//           ? isRetypePasswordValid()
//           : this.isRetypePasswordValid,
//     );
//   }
// }

// class PasswordValidState extends AuthState {
//   final String? value;
//
//   PasswordValidState(this.value);
// }
//
// class RetypePasswordValidState extends AuthState {
//   final String? value;
//
//   RetypePasswordValidState(this.value);
// }
