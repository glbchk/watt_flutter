import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final FetchUpcomingReservedChargingStationsUseCase
  fetchUpcomingReservedChargingStationsUseCase =
      FetchUpcomingReservedChargingStationsUseCase();
  final FetchUpcomingReservationsUseCase fetchUpcomingReservationsUseCase =
      FetchUpcomingReservationsUseCase();
  final DeleteUpcomingReservationUseCase deleteUpcomingReservationUseCase =
      DeleteUpcomingReservationUseCase();
  final ReauthenticateUserUseCase reauthenticateUserUseCase =
      ReauthenticateUserUseCase();
  final FetchOneUpcomingReservedChargingStationUseCase
  fetchOneUpcomingReservedChargingStationUseCase =
      FetchOneUpcomingReservedChargingStationUseCase();
  final StopChargingOrCancelReservationUseCase stopChargingUseCase =
      StopChargingOrCancelReservationUseCase();
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdateUserEmailUseCase updateUserEmailUseCase =
      UpdateUserEmailUseCase();
  final UpdatePhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdatePhoneNumberUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  ReservationsCubit({required this.authBloc})
    : super(ReservationsState(isUserAuthenticated: true, isLoading: true)) {
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthSuccessState) {
        emit(state.copyWith(isUserAuthenticated: true));
      } else if (authState is AuthUnauthenticatedState) {
        emit(state.copyWith(isUserAuthenticated: false));
      }
    });
  }

  Future<void> fetchUpcomingReservationsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final reservations = await fetchUpcomingReservationsUseCase.execute();
      final reservedChargingStations =
          await fetchUpcomingReservedChargingStationsUseCase.execute();

      if (reservedChargingStations != null) {
        print(
          'Upcoming reservations fetched successfully: $reservedChargingStations',
        );
        emit(
          state.copyWith(
            upcomingReservations: reservations,
            reservedChargingStations: reservedChargingStations,
            isLoading: false,
            isUserAuthenticated: true,
          ),
        );
      } else {
        print('Upcoming reservations are null');
        emit(
          state.copyWith(
            upcomingReservations: [],
            reservedChargingStations: [],
            isLoading: false,
            isUserAuthenticated: false,
          ),
        );
      }
    } catch (e) {
      print('Error fetching upcoming reservations: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          upcomingReservations: [],
          reservedChargingStations: [],
          isLoading: false,
        ),
      );
    }
  }

  Future<void> fetchOneUpcomingReservedChargingStation(String stationId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final station = await fetchOneUpcomingReservedChargingStationUseCase
          .execute(
            stationId,
          );

      print('Charging station data fetched successfully: $station');
      emit(
        state.copyWith(
          reservedChargingStation: () => station,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error fetching charging station data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          reservedChargingStation: () => null,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> deleteUpcomingReservation(ReservationModel reservation) async {
    try {
      print('Reservation id in the method: ${reservation}');
      final reservationToDelete = state.upcomingReservations?.firstWhere(
        (b) => b.id == reservation.id,
      );
      if (reservationToDelete == null) return;

      await deleteUpcomingReservationUseCase.execute(reservationToDelete);

      final updatedReservations = (state.upcomingReservations ?? [])
          .where((b) => b.id != reservation.id)
          .toList();

      emit(
        state.copyWith(
          upcomingReservations: updatedReservations,
        ),
      );
    } catch (e) {
      print('Error cancelling reservation $e');
    }
  }

  Future<void> stopChargingOrCancelReservation(
    ReservationModel reservation,
  ) async {
    try {
      // final reservationToDelete = state.upcomingReservations?.firstWhere(
      //   (b) => b.id == reservation.id,
      // );
      // if (reservationToDelete == null) return;

      final updatedUpcomingReservations = (state.upcomingReservations ?? [])
          .where((b) => b.id != reservation.id)
          .toList();

      final updatedPastReservations = <ReservationModel>[
        ...(state.pastReservations ?? []),
        reservation,
      ];

      emit(
        state.copyWith(
          upcomingReservations: updatedUpcomingReservations,
          pastReservations: updatedPastReservations,
        ),
      );

      await stopChargingUseCase.execute(reservation);
    } catch (e) {
      print('Error deleting upcoming reservation $e');
    }
  }

  // Future<void> fetchBookedChargingStations() async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final bookedChargingStations = await fetchBookedChargingStationsUseCase
  //         .execute();
  //     if (bookedChargingStations == null) return;
  //     print('Stations data fetched successfully: $bookedChargingStations');
  //     emit(
  //       state.copyWith(
  //         bookedChargingStations: bookedChargingStations,
  //         isLoading: false,
  //         isUserAuthenticated: true,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error fetching booked charging stations: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: () => e.toString(),
  //         bookedChargingStations: [],
  //         isLoading: false,
  //         clearUserData: true,
  //       ),
  //     );
  //   }
  // }

  // Future<void> editNameUserData(String name) async {
  //   state.copyWith(isLoading: true);
  //
  //   try {
  //     await updateUserNameUseCase.execute(name);
  //
  //     print('User name updated!');
  //     emit(
  //       state.copyWith(
  //         userData: state.userData?.copyUserWith(name: name),
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error changing user name: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: () => e.toString(),
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> editEmailUserData(String email) async {
  //   state.copyWith(isLoading: true);
  //
  //   try {
  //     await updateUserEmailUseCase.execute(email);
  //
  //     print('User email updated!');
  //     emit(
  //       state.copyWith(
  //         userData: state.userData?.copyUserWith(email: email),
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     if (e.toString().contains('requires-recent-login')) {
  //       emit(
  //         state.copyWith(
  //           errorMessage: () => 'reauth-required',
  //           isLoading: false,
  //         ),
  //       );
  //       return;
  //     }
  //
  //     print('Error changing user email: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: () => e.toString(),
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> editPhoneNumberUserData(String phoneNumber) async {
  //   state.copyWith(isLoading: true);
  //
  //   try {
  //     await updateUserPhoneNumberUseCase.execute(phoneNumber);
  //
  //     print('User phone number updated!');
  //     emit(
  //       state.copyWith(
  //         userData: state.userData?.copyUserWith(phoneNumber: phoneNumber),
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error changing user phone number: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: () => e.toString(),
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> reauthenticateUser(
  //   String password,
  //   ProfileDataType type,
  //   String newValue,
  // ) async {
  //   try {
  //     await reauthenticateUserUseCase.execute(password);
  //
  //     await editEmailUserData(newValue);
  //
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         userData: state.userData?.copyUserWith(email: newValue),
  //         passwordError: () => null,
  //         errorMessage: () => null,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         errorMessage: () => "Wrong password. Please try again.",
  //       ),
  //     );
  //   }
  // }

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
