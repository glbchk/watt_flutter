abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

// default state for page
class AuthUnauthenticatedState extends AuthState {
  final bool isRegisterMode;

  AuthUnauthenticatedState(this.isRegisterMode);

  AuthUnauthenticatedState copyWith({bool? isRegisterMode}) {
    return AuthUnauthenticatedState(
      isRegisterMode ?? this.isRegisterMode,
    );
  }
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}
