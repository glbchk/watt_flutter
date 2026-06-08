import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/enum/profile_data_type_enum.dart';

///TODO: NEED TO FIX
class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;
  // StreamSubscription? _emailVerificationSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  // final ListenForEmailVerificationUseCase listenForEmailVerificationUseCase =
  //     ListenForEmailVerificationUseCase();
  final UpdateUserEmailUseCase updateUserEmailUseCase =
      UpdateUserEmailUseCase();
  final ReauthenticateUserUseCase reauthenticateUserUseCase =
      ReauthenticateUserUseCase();
  final SendVerificationEmailUserUseCase sendVerificationEmailUserUseCase =
      SendVerificationEmailUserUseCase();
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final CheckVerificationEmailAndUpdateUseCase
  checkVerificationEmailAndUpdateUseCase =
      CheckVerificationEmailAndUpdateUseCase();
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

  // void startListeningForEmailVerification(String pendingEmail) {
  //   print(
  //     'DEBUG: startListeningForEmailVerification called with $pendingEmail',
  //   );
  //   _emailVerificationSubscription?.cancel();
  //
  //   _emailVerificationSubscription = listenForEmailVerificationUseCase
  //       .execute(pendingEmail)
  //       .listen(
  //         (isVerified) async {
  //           print('DEBUG: stream emitted isVerified=$isVerified');
  //           if (isVerified) {
  //             await fetchUserData();
  //
  //             emit(
  //               state.copyWith(
  //                 isEmailVerified: true,
  //               ),
  //             );
  //
  //             stopListeningForEmailVerification();
  //           }
  //         },
  //         onError: (e) => print('DEBUG: stream error: $e'),
  //         onDone: () => print('DEBUG: stream done'),
  //       );
  //   print('DEBUG: subscription created: $_emailVerificationSubscription');
  // }

  // void stopListeningForEmailVerification() {
  //   _emailVerificationSubscription?.cancel();
  //   _emailVerificationSubscription = null;
  // }

  @override
  Future<void> close() {
    authSubscription.cancel();
    // _emailVerificationSubscription?.cancel();
    return super.close();
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
            email: user.email,
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
    try {
      print('User name updated!');
      await updateUserNameUseCase.execute(name);

      emit(
        state.copyWith(
          name: name,
        ),
      );
    } catch (e) {
      print('Error changing user name: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
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
    try {
      print('User phone number updated!');
      await updateUserPhoneNumberUseCase.execute(phoneNumber);

      emit(
        state.copyWith(
          phoneNumber: phoneNumber,
        ),
      );
    } catch (e) {
      print('Error changing user phone number: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
        ),
      );
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await updateUserEmailUseCase.execute(newEmail);

      if (newEmail != '') {
        emit(
          state.copyWith(
            email: newEmail,
            isEmailVerified: false,
          ),
        );
      }
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        emit(
          state.copyWith(
            errorMessage: () => 'reauth-required',
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: () => e.toString(),
          ),
        );
      }
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
          isEmailVerified: false,
          passwordError: () => null,
          errorMessage: () => null,
        ),
      );
      // startListeningForEmailVerification(newEmail);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: () => '$e',
        ),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await sendVerificationEmailUserUseCase.execute();
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => "Failed to verify email",
        ),
      );
    }
  }

  Future<void> checkVerificationEmailAndUpdate(String pendingEmail) async {
    try {
      final isVerified = await checkVerificationEmailAndUpdateUseCase.execute(
        pendingEmail,
      );

      if (isVerified) {
        await fetchUserData();
        emit(
          state.copyWith(
            isEmailVerified: true,
          ),
        );
      }
    } catch (e) {
      print("Error checking verification: $e");
      emit(
        state.copyWith(
          errorMessage: () => 'Not possible to update if the email verified.',
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
