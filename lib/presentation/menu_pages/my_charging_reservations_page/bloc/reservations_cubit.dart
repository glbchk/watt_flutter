import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_state.dart';

class ReservationsCubit extends Cubit<ReservationsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final FetchBookedChargingStationsUseCase fetchBookedChargingStationsUseCase =
      FetchBookedChargingStationsUseCase();
  final FetchBookingsUseCase fetchBookingsUseCase = FetchBookingsUseCase();
  final DeleteBookingUseCase deleteBookingUseCase = DeleteBookingUseCase();
  final ReauthenticateUserUseCase reauthenticateUserUseCase =
      ReauthenticateUserUseCase();
  final FetchOneBookedChargingStationUseCase
  fetchOneBookedChargingStationUseCase = FetchOneBookedChargingStationUseCase();
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

  Future<void> fetchBookingData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final bookings = await fetchBookingsUseCase.execute();
      final bookedChargingStations = await fetchBookedChargingStationsUseCase
          .execute();

      if (bookedChargingStations != null) {
        print('User data fetched successfully: $bookedChargingStations');
        emit(
          state.copyWith(
            bookings: bookings,
            bookedChargingStations: bookedChargingStations,
            isLoading: false,
            isUserAuthenticated: true,
          ),
        );
      } else {
        print('User data is null');
        emit(
          state.copyWith(
            bookings: [],
            bookedChargingStations: [],
            isLoading: false,
            isUserAuthenticated: false,
          ),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          bookings: [],
          bookedChargingStations: [],
          isLoading: false,
        ),
      );
    }
  }

  Future<void> fetchOneBookedChargingStation(String stationId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final station = await fetchOneBookedChargingStationUseCase.execute(
        stationId,
      );

      print('Charging station data fetched successfully: $station');
      emit(
        state.copyWith(
          bookedChargingStation: () => station,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error fetching charging station data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          bookedChargingStation: () => null,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> deleteBooking(BookingModel booking) async {
    try {
      print('Booking id in the method: ${booking}');
      final bookingToDelete = state.bookings?.firstWhere(
        (b) => b.id == booking.id,
      );
      if (bookingToDelete == null) return;

      await deleteBookingUseCase.execute(bookingToDelete);

      final updatedBookings = (state.bookings ?? [])
          .where((b) => b.id != booking.id)
          .toList();

      emit(
        state.copyWith(
          bookings: updatedBookings,
        ),
      );
    } catch (e) {
      print('Error cancelling booking $e');
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
