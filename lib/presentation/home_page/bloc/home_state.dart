abstract class HomeState {}

class AuthInitialState extends HomeState {}

class AuthSuccessState extends HomeState {}

class FirstTimeAuthState extends HomeState {}

class SignInAnonymouslyState extends HomeState {}

class AuthErrorState extends HomeState {
  final String message;
  AuthErrorState(this.message);
}

class AuthUnauthenticatedState extends HomeState {
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
    String? errorMessage,
    String? emailError,
    String? passwordError,
    String? retypePasswordError,
    String? forgotPasswordError,
    bool? isPasswordVisible,
    bool? isRetypePasswordVisible,
  }) {
    return AuthUnauthenticatedState(
      isRegisterMode: isRegisterMode ?? this.isRegisterMode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
      retypePasswordError: retypePasswordError,
      forgotPasswordError: forgotPasswordError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRetypePasswordVisible:
          isRetypePasswordVisible ?? this.isRetypePasswordVisible,
    );
  }
}
