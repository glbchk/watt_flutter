import 'package:watt/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthSuccessState extends AuthState {}

class FirstTimeAuthState extends AuthState {}

class SignInAnonymouslyState extends AuthState {}

// default state for page
class AuthUnauthenticatedState extends AuthState {
  final bool isRegisterMode;
  final bool isLoading;
  final String? errorMessage;

  final String? emailError;
  final String? passwordError;
  final String? retypePasswordError;
  final String? forgotPasswordError;

  final bool? isPasswordVisible;
  final bool? isRetypePasswordVisible;

  AuthUnauthenticatedState({
    required this.isRegisterMode,
    this.isLoading = false,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.retypePasswordError,
    this.forgotPasswordError,
    this.isPasswordVisible = false,
    this.isRetypePasswordVisible = false,
  });

  AuthUnauthenticatedState copyWith({
    bool? isRegisterMode,
    bool? isLoading,
    String? Function()? errorMessage,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? retypePasswordError,
    String? Function()? forgotPasswordError,
    bool? isPasswordVisible,
    bool? isRetypePasswordVisible,
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
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRetypePasswordVisible:
          isRetypePasswordVisible ?? this.isRetypePasswordVisible,
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
