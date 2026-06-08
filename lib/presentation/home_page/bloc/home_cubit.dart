import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;
  final ProfileCubit profileCubit;
  late StreamSubscription profileSubscription;

  final SeedMockedChargingStationsUseCase seedMockedChargingStationsUseCase =
      SeedMockedChargingStationsUseCase();
  final GetStationIdsForMapUseCase getStationIdsForMap =
      GetStationIdsForMapUseCase();
  FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();
  final GetLocationPermissionUseCase getLocationPermissionUseCase =
      GetLocationPermissionUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final GetDistanceToUseCase getDistanceToUseCase = GetDistanceToUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final FetchOneChargingStationUseCase fetchOneChargingStationUseCase =
      FetchOneChargingStationUseCase();
  final FetchAllChargingStationsUseCase fetchAllChargingStationsUseCase =
      FetchAllChargingStationsUseCase();
  final FetchOneUpcomingReservationUseCase fetchOneReservationUseCase =
      FetchOneUpcomingReservationUseCase();
  final ConfirmUpcomingReservationWithPaymentUseCase
  confirmUpcomingReservationWithPaymentUseCase =
      ConfirmUpcomingReservationWithPaymentUseCase();
  final DeleteUpcomingReservationUseCase deleteReservationUseCase =
      DeleteUpcomingReservationUseCase();
  final UpdateChargingStationsOnMapUseCase updateChargingStationsOnMapUseCase =
      UpdateChargingStationsOnMapUseCase();
  final FetchFaqUseCase fetchFaqUseCase = FetchFaqUseCase();

  HomeCubit({required this.authBloc, required this.profileCubit})
    : super(HomeState(isUserAuthenticated: true, isLoading: true)) {
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthSuccessState) {
        emit(state.copyWith(isUserAuthenticated: true));
      } else if (authState is AuthUnauthenticatedState) {
        emit(state.copyWith(isUserAuthenticated: false));
      }
    });
    profileSubscription = profileCubit.stream.listen((profileState) {
      if (profileState.userData != null) {
        emit(state.copyWith(userData: profileState.userData));
      }
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    profileSubscription.cancel();
    return super.close();
  }

  Future<void> getLocationPermission() async {
    try {
      final hasPermission = await getLocationPermissionUseCase.execute();

      emit(
        state.copyWith(
          isLocationEnabled: hasPermission,
          isLoading: false,
          errorMessage: () =>
              hasPermission ? null : 'Location permission denied',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLocationEnabled: false,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> goToMyLocation() async {
    if (state.isLocationEnabled != true) {
      await getLocationPermission();
      if (state.isLocationEnabled != true) {
        emit(
          state.copyWith(
            errorMessage: () => 'Location permission not granted',
          ),
        );
        return;
      }
    }

    try {
      final position = await goToMyLocationUseCase.execute();

      if (position != null) {
        emit(
          state.copyWith(
            isLoading: false,
            myLocation: position,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: () => 'Could not get location',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
    }
  }

  Future<void> seedMockedChargingStations() async {
    try {
      await seedMockedChargingStationsUseCase.execute(
        KMockedData.mockedAddedByUsersChargingStations,
      );
      await seedMockedChargingStationsUseCase.execute(
        KMockedData.mockedPublicChargingStations,
      );
      final allStations = await fetchAllChargingStationsUseCase.execute();
      final result = await getStationIdsForMap.execute();

      emit(
        state.copyWith(
          isLoading: false,
          chargingStationsOnMap: allStations,
          userStationIds: result['user'],
          globalStationIds: result['global'],
          errorMessage: () => allStations.isEmpty ? 'No stations found' : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final methods = await fetchPaymentMethodsUseCase.execute();

      if (methods.isNotEmpty) {
        emit(state.copyWith(paymentMethods: methods));
        return;
      } else {
        emit(state.copyWith(paymentMethods: []));
        return;
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> confirmUpcomingReservationWithPayment(
    ReservationModel upcomingReservation,
    BookingModel upcomingBooking,
    String cardNumber,
  ) async {
    try {
      final busySlots = (upcomingReservation.selectedTimes ?? [])
          .map((s) => s.copyWith(isBusy: true))
          .toList();

      final confirmedReservation = upcomingReservation.copyWith(
        selectedTimes: busySlots,
        cardNumber: cardNumber,
      );

      final updatedReservations = <ReservationModel>[
        ...(state.upcomingReservations ?? []),
        confirmedReservation,
      ];

      final confirmedBooking = upcomingBooking.copyWith(
        selectedTimes: busySlots,
        cardNumber: cardNumber,
      );

      final updatedBookings = <BookingModel>[
        ...(state.upcomingBookings ?? []),
        confirmedBooking,
      ];
      final updatedTimeSlots = state.timeSlots?.map((slot) {
        final isSelected = busySlots.any(
          (s) => s.startTime == slot.startTime && s.endTime == slot.endTime,
        );
        return isSelected ? slot.copyWith(isBusy: true) : slot;
      }).toList();

      emit(
        state.copyWith(
          upcomingReservations: updatedReservations,
          upcomingBookings: updatedBookings,
          timeSlots: updatedTimeSlots,
        ),
      );

      await confirmUpcomingReservationWithPaymentUseCase.execute(
        confirmedReservation,
        confirmedBooking,
        cardNumber,
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> getDistanceToChargingStation(
    double targetLatitude,
    double targetLongitude,
  ) async {
    try {
      if (state.isLocationEnabled != true) {
        await getLocationPermission();
        if (state.isLocationEnabled != true) {
          emit(
            state.copyWith(
              errorMessage: () => 'Location permission not granted',
            ),
          );
          return;
        }
      }

      if (state.myLocation == null) {
        await goToMyLocation();
      }

      final position = state.myLocation;

      final distance = await getDistanceToUseCase.execute(
        position,
        targetLatitude,
        targetLongitude,
      );

      if (distance != null) {
        emit(
          state.copyWith(
            isLoading: false,
            stationDistance: distance,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: () => 'Could not get location',
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
    }
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

      final result = await getStationIdsForMap.execute();

      if (result.isNotEmpty) {
        emit(
          state.copyWith(
            userStationIds: result['user'],
            globalStationIds: result['global'],
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

  Future<void> fetchOneChargingStation(String stationId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final stations = state.chargingStationsOnMap ?? [];

      print("Looking for stationId: $stationId");
      print("Available stations: ${stations.map((e) => e.id).toList()}");

      if (stations.isEmpty) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final station = stations.firstWhere(
        (s) => s.id == stationId,
        orElse: () => throw Exception("Station not found"),
      );

      final availableHours = StringHelperMethods.convertTimeSlotsToTimeRange(
        station.availableHours ?? [],
      );

      final reservationFuture = fetchOneReservationUseCase.execute(stationId);

      final List<SlotModel> generatedSlots = [];

      for (final timeSlot in station.availableHours ?? []) {
        final slot = StringHelperMethods.generate30MinuteSlots(
          timeSlot,
          [],
        );
        generatedSlots.addAll(slot);
      }

      final reservationDoc = await reservationFuture;
      List<SlotModel> busySlots = reservationDoc?.selectedTimes ?? [];

      final updatedSlots = generatedSlots.map((slot) {
        final isBusy = busySlots.any(
          (s) => s.startTime == slot.startTime && s.endTime == slot.endTime,
        );
        return isBusy ? slot.copyWith(isBusy: true) : slot;
      }).toList();

      emit(
        state.copyWith(
          chargingStation: () => station,
          timeSlots: updatedSlots,
          selectedSlots: () => busySlots,
          availableTime: availableHours,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error fetching charging station: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  void toggleSlot(String slotId) {
    final List<SlotModel> updatedSlots = List.from(
      state.selectedSlots ?? [],
    );

    final slot = state.timeSlots?.firstWhere(
      (s) => s.id == slotId,
    );

    final alreadySelected = updatedSlots.any((s) => s.id == slotId);
    if (alreadySelected) {
      updatedSlots.removeWhere((s) => s.id == slotId);
    } else {
      if (slot != null) updatedSlots.add(slot);
    }

    print(updatedSlots);

    emit(
      state.copyWith(
        selectedSlots: () => updatedSlots,
        errorTimeIsNotChosen: () => null,
      ),
    );
  }

  Future<void> timeIsNotChosen() async {
    if (state.selectedSlots?.isEmpty ?? false) {
      emit(
        state.copyWith(
          errorTimeIsNotChosen: () => "The time wasn't chosen!",
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorTimeIsNotChosen: null,
        ),
      );
    }
  }

  Future<void> reservationRequestedStage(ReservationModel reservation) async {
    try {
      final List<ReservationModel> updatedReservations = List.from(
        state.upcomingReservations ?? [],
      );

      updatedReservations.add(reservation);

      emit(
        state.copyWith(
          upcomingReservations: updatedReservations,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> fetchOneUpcomingReservation(String reservationId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final reservation = state.upcomingReservations?.firstWhere(
        (b) => b.id == reservationId,
      );
      if (reservation == null) return;
      print('Reservation fetched successfully: $reservation');
      emit(
        state.copyWith(
          reservation: () => reservation,
          isLoading: false,
          isUserAuthenticated: true,
        ),
      );
    } catch (e) {
      print('Error fetching reservation: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          reservation: () => null,
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }

  Future<void> clearUpcomingReservationState() async {
    try {
      emit(
        state.copyWith(
          selectedSlots: () => null,
          reservation: () => null,
          errorTimeIsNotChosen: () => null,
        ),
      );
    } catch (e) {
      print("Can't be cleared $e");
    }
  }

  Future<void> fetchChargingStationsForMap() async {
    try {
      final allStations = await fetchAllChargingStationsUseCase.execute();

      final result = await getStationIdsForMap.execute();

      emit(
        state.copyWith(
          chargingStationsOnMap: allStations,
          userStationIds: result['user'],
          globalStationIds: result['global'],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> updateChargingStationsOnMap(
    List<ChargingStationModel> stations,
  ) async {
    try {
      final updatedStations = await updateChargingStationsOnMapUseCase.execute(
        stations,
      );

      emit(
        state.copyWith(
          chargingStationsOnMap: updatedStations,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  String inviteFriends() {
    if (Platform.isIOS) {
      return "https://www.apple.com/app-store/";
    } else if (Platform.isAndroid) {
      return "https://play.google.com/";
    } else {
      return "Unknown platform";
    }
  }

  Future<void> fetchFaq() async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<MockedFaq> faq = await fetchFaqUseCase.execute();
      print('FAQ fetched successfully: $faq');
      emit(
        state.copyWith(
          faq: faq,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error fetching FAQ: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@watt.co',
      queryParameters: {
        'subject': 'Support Request',
        'body': 'Hello, I have a question about...',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Handle the error if no mail app is available
      debugPrint('Could not launch mail app');
    }
  }
}
