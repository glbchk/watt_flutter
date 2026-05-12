import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_state.dart';

abstract class ChargingActionInterface {
  void stopChargingOrCancelReservation(
    ReservationModel reservation,
    BookingModel booking,
  );
}

class ReservationsCubit extends Cubit<ReservationsState>
    implements ChargingActionInterface {
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
  final StopChargingOrCancelReservationUseCase stopChargingUseCase =
      StopChargingOrCancelReservationUseCase();
  final FetchUpcomingBookingsUseCase fetchUpcomingBookingsUseCase =
      FetchUpcomingBookingsUseCase();
  final FetchPastBookingsUseCase fetchPastBookingsUseCase =
      FetchPastBookingsUseCase();

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

  Future<void> fetchUpcomingPastReservationsAndBookingsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        fetchUpcomingReservationsUseCase.execute(),
        fetchPastReservationsUseCase.execute(),
        fetchAllChargingStationsUseCase.execute(),
        fetchUpcomingBookingsUseCase.execute(),
        fetchPastBookingsUseCase.execute(),
      ]);

      emit(
        state.copyWith(
          upcomingReservations: results[0] as List<ReservationModel>,
          pastReservations: results[1] as List<ReservationModel>,
          reservedChargingStations: results[2] as List<ChargingStationModel>,
          upcomingBookings: results[3] as List<BookingModel>,
          pastBookings: results[4] as List<BookingModel>,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          upcomingReservations: [],
          pastReservations: [],
          reservedChargingStations: [],
          upcomingBookings: [],
          pastBookings: [],
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

  @override
  Future<void> stopChargingOrCancelReservation(
    ReservationModel reservation,
    BookingModel booking,
  ) async {
    try {
      final updatedUpcomingReservations = (state.upcomingReservations ?? [])
          .where((r) => r.id != reservation.id)
          .toList();

      final updatedPastReservations = <ReservationModel>[
        ...(state.pastReservations ?? []),
        reservation,
      ];

      final updatedUpcomingBookings = (state.upcomingBookings ?? [])
          .where((b) => b.id != booking.id)
          .toList();

      final updatedPastBookings = <BookingModel>[
        ...(state.pastBookings ?? []),
        booking,
      ];

      emit(
        state.copyWith(
          upcomingReservations: updatedUpcomingReservations,
          upcomingBookings: updatedUpcomingBookings,
          pastReservations: updatedPastReservations,
          pastBookings: updatedPastBookings,
        ),
      );

      await stopChargingUseCase.execute(reservation, booking);
      // await closeBookingUseCase.execute(booking);
    } catch (e) {
      print('Error deleting upcoming reservation $e');
    }
  }
}
