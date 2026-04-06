import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
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
          errorMessage: e.toString(),
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }

  // void setUserData(UserModel? user) async {
  //   if (user != null) {
  //     emit(
  //       state.copyWith(
  //         userData: user,
  //         isLoading: false,
  //       ),
  //     );
  //   } else {
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         clearUserData: true,
  //       ),
  //     );
  //   }
  // }

  Future<void> logout() async {
    try {
      await logoutUserUseCase.execute();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }
}
