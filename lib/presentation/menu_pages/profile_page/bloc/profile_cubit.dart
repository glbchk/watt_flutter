import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/enum/profile_data_type_enum.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final ReauthenticateUserUseCase reauthenticateUserUseCase =
      ReauthenticateUserUseCase();
  final VerifyEmailUserUseCase verifyEmailUserUseCase =
      VerifyEmailUserUseCase();
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdateUserEmailUseCase updateUserEmailUseCase =
      UpdateUserEmailUseCase();
  final UpdatePhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdatePhoneNumberUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  ProfileCubit({required this.authBloc})
    : super(ProfileState(isUserAuthenticated: true, isLoading: true)) {
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthSuccessState) {
        emit(state.copyWith(isUserAuthenticated: true));
      } else if (authState is AuthUnauthenticatedState) {
        emit(state.copyWith(isUserAuthenticated: false));
      }
    });
  }

  Future<void> fetchUserData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await getUserDataUseCase.execute();
      if (user != null) {
        print('User data fetched successfully: $user');
        emit(
          state.copyWith(
            userData: user,
            isEmailVerified: user.isEmailVerified,
            isLoading: false,
            isUserAuthenticated: true,
          ),
        );
      } else {
        print('User data is null');
        emit(
          state.copyWith(
            isLoading: false,
            isUserAuthenticated: false,
            clearUserData: true,
          ),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }

  Future<void> editNameUserData(String name) async {
    // emit(state.copyWith(isLoading: true));
    try {
      print('User name updated!');
      await updateUserNameUseCase.execute(name);

      emit(
        state.copyWith(
          name: name,
          // isLoading: false,
        ),
      );
    } catch (e) {
      print('Error changing user name: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          // isLoading: false,
        ),
      );
    }
  }

  Future<void> editEmailUserData(String email) async {
    // emit(state.copyWith(isLoading: true));
    try {
      print('User email updated!');
      await updateUserEmailUseCase.execute(email);

      emit(
        state.copyWith(
          email: email,
          // isLoading: false,
        ),
      );
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        emit(
          state.copyWith(
            errorMessage: () => 'reauth-required',
            // isLoading: false,
          ),
        );
        return;
      }

      print('Error changing user email: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          // isLoading: false,
        ),
      );
    }
  }

  void clearError() {
    emit(
      state.copyWith(
        errorMessage: () => null,
        nameError: () => null,
        emailError: () => null,
        phoneNumberError: () => null,
        passwordError: () => null,
      ),
    );
  }

  Future<void> editPhoneNumberUserData(String phoneNumber) async {
    // emit(state.copyWith(isLoading: true));
    try {
      print('User phone number updated!');
      await updateUserPhoneNumberUseCase.execute(phoneNumber);

      emit(
        state.copyWith(
          phoneNumber: phoneNumber,
          // isLoading: false,
        ),
      );
    } catch (e) {
      print('Error changing user phone number: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          // isLoading: false,
        ),
      );
    }
  }

  Future<void> reauthenticateUser(
    String currentPassword,
    ProfileDataType type,
    String newEmail,
  ) async {
    try {
      await reauthenticateUserUseCase.execute(currentPassword, newEmail);

      emit(
        state.copyWith(
          isLoading: false,
          email: newEmail,
          isEmailVerified: false,
          passwordError: () => null,
          errorMessage: () => null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: () => "Wrong password. Please try again.",
        ),
      );
    }
  }

  Future<void> verifyEmail() async {
    try {
      await verifyEmailUserUseCase.execute();

      final updatedUser = await getUserDataUseCase.execute();

      emit(
        state.copyWith(
          isEmailVerified: updatedUser?.isEmailVerified ?? false,
          userData: updatedUser,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => "Failed to verify email",
        ),
      );
    }
  }

  Future<void> verifyNameUserData(String value) async {
    if (value.length < 3) {
      emit(
        state.copyWith(
          nameError: () => "Name need to have at least 3 symbols",
        ),
      );
      return;
    }

    emit(
      state.copyWith(nameError: () => null, isLoading: true),
    );
  }

  Future<void> verifyEmailUserData(String value) async {
    if (!(value.contains('@') && value.contains('.'))) {
      emit(
        state.copyWith(
          emailError: () => "Email is not valid",
        ),
      );
      return;
    }

    emit(
      state.copyWith(emailError: () => null, isLoading: true),
    );
  }

  Future<void> verifyPhoneNumberUserData(String value) async {
    if (value.length < 10) {
      emit(
        state.copyWith(
          phoneNumberError: () =>
              "Phone number need to have at least 10 symbols",
        ),
      );
      return;
    }

    emit(
      state.copyWith(phoneNumberError: () => null, isLoading: true),
    );
  }

  Future<void> verifyPasswordUserData(String value) async {
    if (value.length < 6) {
      emit(
        state.copyWith(
          passwordError: () => "Password should be longer than 6 digits",
        ),
      );
      return;
    }

    emit(
      state.copyWith(passwordError: () => null, isLoading: true),
    );
  }
}
