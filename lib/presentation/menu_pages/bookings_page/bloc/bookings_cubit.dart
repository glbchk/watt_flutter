import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/bookings_page/bloc/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final FetchAllChargingStationsUseCase fetchAllChargingStationsUseCase =
      FetchAllChargingStationsUseCase();
  final FetchUpcomingReservationsUseCase fetchUpcomingReservationsUseCase =
      FetchUpcomingReservationsUseCase();
  final FetchPastReservationsUseCase fetchPastReservationsUseCase =
      FetchPastReservationsUseCase();
  final DeleteUpcomingReservationUseCase deleteUpcomingReservationUseCase =
      DeleteUpcomingReservationUseCase();
  final ReauthenticateUserUseCase reauthenticateUserUseCase =
      ReauthenticateUserUseCase();
  final FetchOneUpcomingReservedChargingStationUseCase
  fetchOneUpcomingReservedChargingStationUseCase =
      FetchOneUpcomingReservedChargingStationUseCase();
  final FetchUpcomingBookingsUseCase fetchUpcomingBookingsUseCase =
      FetchUpcomingBookingsUseCase();
  final FetchPastBookingsUseCase fetchPastBookingsUseCase =
      FetchPastBookingsUseCase();

  BookingsCubit({required this.authBloc})
    : super(BookingsState(isUserAuthenticated: true, isLoading: true)) {
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthSuccessState) {
        emit(state.copyWith(isUserAuthenticated: true));
      } else if (authState is AuthUnauthenticatedState) {
        emit(state.copyWith(isUserAuthenticated: false));
      }
    });
  }

  Future<void> fetchUpcomingAndPastBookingsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        fetchUpcomingBookingsUseCase.execute(),
        // fetchPastReservationsUseCase.execute(),
        fetchAllChargingStationsUseCase.execute(),
      ]);

      emit(
        state.copyWith(
          upcomingBookings: results[0] as List<BookingModel>,
          // pastBookings: results[1] as List<BookingsModel>,
          bookedChargingStations: results[1] as List<ChargingStationModel>,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          upcomingBookings: [],
          pastBookings: [],
          bookedChargingStations: [],
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

  Future<void> deleteUpcomingReservation(BookingModel booking) async {
    ///TODO: NEED TO BE FIXED
    try {
      print('Booking id in the method: ${booking}');
      final bookingToDelete = state.upcomingBookings?.firstWhere(
        (b) => b.id == booking.id,
      );
      if (bookingToDelete == null) return;

      // await deleteUpcomingReservationUseCase.execute(BookingModel(id: ''));

      final updatedBookings = (state.upcomingBookings ?? [])
          .where((b) => b.id != booking.id)
          .toList();

      emit(
        state.copyWith(
          upcomingBookings: updatedBookings,
        ),
      );
    } catch (e) {
      print('Error cancelling booking $e');
    }
  }
}
