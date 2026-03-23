import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  // final RegisterUserUseCase registerUserUseCase = RegisterUserUseCase();
  // final IsLoggedInUserUseCase isLoggedInUserUseCase = IsLoggedInUserUseCase();
  // final LoginUserUseCase loginUserUseCase = LoginUserUseCase();
  // final SignInAnonymouslyUseCase signInAnonymouslyUseCase =
  //     SignInAnonymouslyUseCase();
  // final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase =
  //     SendPasswordResetEmailUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  HomeCubit() : super(AuthInitialState());

  // ── Helpers ──────────────────────────────────────────
  AuthUnauthenticatedState? get _unauthState =>
      state is AuthUnauthenticatedState
      ? state as AuthUnauthenticatedState
      : null;

  // String? _validateEmail(String value) {
  //   if (value.isEmpty) return 'Email required';
  //   if (!value.contains('@') || !value.contains('.')) return 'Invalid email';
  //   return null;
  // }
  //
  // String? _validatePassword(String value) {
  //   if (value.isEmpty) return 'Password required';
  //   if (value.length < 6) return 'Password must be at least 6 characters';
  //   return null;
  // }
  //
  // String? _validateRetypePassword(String password, String retype) {
  //   if (retype.isEmpty) return 'Please retype password';
  //   if (password != retype) return 'Passwords do not match';
  //   return null;
  // }

  // ── Methods (replaces Events) ─────────────────────────

  void changeAuthMode(bool isRegisterMode) {
    final s = _unauthState;
    if (s != null) {
      emit(s.copyWith(isRegisterMode: isRegisterMode));
    } else {
      emit(AuthUnauthenticatedState(isRegisterMode: isRegisterMode));
    }
  }

  // Future<void> checkIfLoggedIn() async {
  //   try {
  //     final isLoggedIn = await isLoggedInUserUseCase.execute();
  //     emit(
  //       isLoggedIn
  //           ? AuthSuccessState()
  //           : AuthUnauthenticatedState(isRegisterMode: false),
  //     );
  //   } catch (e) {
  //     emit(AuthErrorState(e.toString()));
  //   }
  // }
  //
  // Future<void> register({
  //   required String email,
  //   required String password,
  //   required String retypePassword,
  // }) async {
  //   final s = _unauthState;
  //   if (s != null) {
  //     final emailError = _validateEmail(email);
  //     final passwordError = _validatePassword(password);
  //     final retypeError = _validateRetypePassword(password, retypePassword);
  //
  //     if (emailError != null || passwordError != null || retypeError != null) {
  //       emit(
  //         s.copyWith(
  //           emailError: emailError,
  //           passwordError: passwordError,
  //           retypePasswordError: retypeError,
  //         ),
  //       );
  //       return;
  //     }
  //   }
  //
  //   try {
  //     await registerUserUseCase.execute(email, password);
  //     emit(FirstTimeAuthState());
  //   } catch (e) {
  //     emit(AuthErrorState(e.toString()));
  //   }
  // }
  //
  // Future<void> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final s = _unauthState;
  //   if (s == null) return;
  //
  //   final emailError = _validateEmail(email);
  //   final passwordError = _validatePassword(password);
  //
  //   if (emailError != null || passwordError != null) {
  //     emit(s.copyWith(emailError: emailError, passwordError: passwordError));
  //     return;
  //   }
  //
  //   emit(s.copyWith(isLoading: true));
  //
  //   try {
  //     await loginUserUseCase.execute(email, password);
  //     emit(AuthSuccessState());
  //   } catch (e) {
  //     emit(s.copyWith(isLoading: false, errorMessage: e.toString()));
  //   }
  // }

  Future<void> logout() async {
    try {
      await logoutUserUseCase.execute();
      emit(AuthUnauthenticatedState(isRegisterMode: false));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  // Future<void> signInAnonymously() async {
  //   try {
  //     await signInAnonymouslyUseCase.execute();
  //     emit(SignInAnonymouslyState());
  //   } catch (e) {
  //     emit(AuthErrorState(e.toString()));
  //   }
  // }

  void clearEmailError() {
    final s = _unauthState;
    if (s != null) emit(s.copyWith(emailError: null));
  }

  void clearPasswordError() {
    final s = _unauthState;
    if (s != null) emit(s.copyWith(passwordError: null));
  }

  void clearRetypePasswordError() {
    final s = _unauthState;
    if (s != null) emit(s.copyWith(retypePasswordError: null));
  }

  void togglePasswordVisibility() {
    final s = _unauthState;
    if (s != null)
      emit(s.copyWith(isPasswordVisible: !(s.isPasswordVisible ?? false)));
  }

  void toggleRetypePasswordVisibility() {
    final s = _unauthState;
    if (s != null)
      emit(
        s.copyWith(
          isRetypePasswordVisible: !(s.isRetypePasswordVisible ?? false),
        ),
      );
  }

  void clearSnackBarError() {
    final s = _unauthState;
    if (s != null) emit(s.copyWith(errorMessage: null));
  }

  Future<void> validateForgotPasswordEmail(String email) async {
    final s = _unauthState;
    if (s == null) return;
    final error =
        email.isEmpty || (!email.contains('@') || !email.contains('.'))
        ? 'Invalid email'
        : null;
    emit(s.copyWith(forgotPasswordError: error));
  }

  // Future<void> sendPasswordResetEmail(String email) async {
  //   try {
  //     await sendPasswordResetEmailUseCase.execute(email);
  //     emit(AuthUnauthenticatedState(isRegisterMode: false));
  //   } catch (e) {
  //     emit(AuthErrorState(e.toString()));
  //   }
  // }
}
