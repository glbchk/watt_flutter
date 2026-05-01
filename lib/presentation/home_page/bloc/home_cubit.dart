import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;
  final ProfileCubit profileCubit;
  late StreamSubscription profileSubscription;

  final SeedMockedChargingStationsUseCase seedMockedChargingStationsUseCase =
      SeedMockedChargingStationsUseCase();
  // final SyncStationToGlobalUseCase syncStationToGlobalUseCase =
  //     SyncStationToGlobalUseCase();
  final GetStationIdsForMapUseCase getStationIdsForMap =
      GetStationIdsForMapUseCase();
  FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();
  // final FetchAddedByUsersMockedChargingStationsUseCase
  // fetchAddedByUsersMockedChargingStationsUseCase =
  //     FetchAddedByUsersMockedChargingStationsUseCase();
  // final FetchPublicMockedChargingStationsUseCase
  // fetchPublicMockedChargingStationsUseCase =
  //     FetchPublicMockedChargingStationsUseCase();
  final GetLocationPermissionUseCase getLocationPermissionUseCase =
      GetLocationPermissionUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final GetDistanceToUseCase getDistanceToUseCase = GetDistanceToUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final FetchOneChargingStationUseCase fetchOneChargingStationUseCase =
      FetchOneChargingStationUseCase();
  final AddBookingUseCase addBookingUseCase = AddBookingUseCase();
  final SetSlotIsBusyUseCase setSlotIsBusyUseCase = SetSlotIsBusyUseCase();
  final DeleteBookingUseCase deleteBookingUseCase = DeleteBookingUseCase();
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
            isLoading: true,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
    }
  }

  Future<void> seedMockedChargingStations() async {
    try {
      // await syncStationToGlobalUseCase.execute();
      await seedMockedChargingStationsUseCase.execute(
        KMockedData.mockedAddedByUsersChargingStations,
      );
      await seedMockedChargingStationsUseCase.execute(
        KMockedData.mockedPublicChargingStations,
      );
      final List<ChargingStationModel> chargingStationsOnMap = [];
      chargingStationsOnMap.addAll(
        KMockedData.mockedAddedByUsersChargingStations,
      );
      chargingStationsOnMap.addAll(KMockedData.mockedPublicChargingStations);
      chargingStationsOnMap.addAll(state.userData?.chargingStations ?? []);
      final result = await getStationIdsForMap.execute();

      emit(
        state.copyWith(
          isLoading: false,
          chargingStationsOnMap: chargingStationsOnMap,
          userStationIds: result['user'],
          globalStationIds: result['global'],
          errorMessage: () =>
              chargingStationsOnMap.isEmpty ? 'No stations found' : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      final methods = state.userData?.paymentMethods;

      if (methods != null) {
        emit(state.copyWith(paymentMethods: methods));
        return;
      }

      final paymentMethods = await fetchPaymentMethodsUseCase.execute();

      emit(state.copyWith(paymentMethods: paymentMethods));
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> setSlotIsBusy(
    String bookingId,
    List<SlotModel> selectedSlots,
    String cardNumber,
  ) async {
    try {
      final selectedIds = selectedSlots.map((s) => s.id).toSet();

      final updatedBookings = state.bookings?.map((booking) {
        if (booking.id == bookingId) {
          final updatedSlots = booking.selectedTimes?.map((slot) {
            if (selectedIds.contains(slot.id)) {
              return slot.copyWith(isBusy: true);
            }
            return slot;
          }).toList();

          return booking.copyWith(
            selectedTimes: updatedSlots,
            cardNumber: cardNumber,
          );
        }
        return booking;
      }).toList();

      final updatedTimeSlots = state.timeSlots?.map((slot) {
        if (selectedIds.contains(slot.id)) {
          return slot.copyWith(isBusy: true);
        }
        return slot;
      }).toList();

      emit(
        state.copyWith(
          bookings: updatedBookings,
          timeSlots: updatedTimeSlots,
        ),
      );

      await setSlotIsBusyUseCase.execute(
        bookingId,
        selectedSlots,
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
            isLoading: true,
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
      final station = state.chargingStationsOnMap?.firstWhere(
        (station) => station.id == stationId,
      );
      if (station == null) return;
      print('Station data fetched successfully: $station');

      final List<SlotModel> generatedSlots = [];
      for (final timeSlot in station.availableHours ?? []) {
        final slot = StringHelperMethods.generate30MinuteSlots(timeSlot);
        generatedSlots.addAll(slot);
      }

      emit(
        state.copyWith(
          chargingStation: () => station,
          timeSlots: generatedSlots,
          isLoading: false,
          isUserAuthenticated: true,
        ),
      );
    } catch (e) {
      print('Error fetching user data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          chargingStation: () => null,
          isLoading: false,
          clearUserData: true,
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
          // stage: () => ReservationStage.booking,
          // isBooked: false,
          errorTimeIsNotChosen: () => "The time wasn't chosen!",
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorTimeIsNotChosen: null,
          // isBooked: false,
        ),
      );
    }
  }

  Future<void> reservationRequestedStage(BookingModel booking) async {
    try {
      await addBookingUseCase.execute(booking);

      final List<BookingModel> updatedBookings = List.from(
        state.bookings ?? [],
      );

      updatedBookings.add(booking);

      emit(
        state.copyWith(
          bookings: updatedBookings,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> fetchOneBooking(String bookingId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final booking = state.bookings?.firstWhere(
        (b) => b.id == bookingId,
      );
      if (booking == null) return;
      print('Station data fetched successfully: $booking');
      emit(
        state.copyWith(
          booking: () => booking,
          isLoading: false,
          isUserAuthenticated: true,
        ),
      );
    } catch (e) {
      print('Error fetching user data: $e');
      emit(
        state.copyWith(
          errorMessage: () => e.toString(),
          booking: () => null,
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }

  Future<void> clearBookingState() async {
    try {
      emit(
        state.copyWith(
          selectedSlots: () => null,
          booking: () => null,
          errorTimeIsNotChosen: () => null,
        ),
      );
    } catch (e) {
      print("Can't be cleared $e");
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      print('Booking id in the method: ${bookingId}');
      final bookingToDelete = state.bookings?.firstWhere(
        (b) => b.id == bookingId,
      );
      if (bookingToDelete == null) return;

      await deleteBookingUseCase.execute(bookingToDelete);

      final updatedBookings = (state.bookings ?? [])
          .where((b) => b.id != bookingId)
          .toList();

      emit(
        state.copyWith(
          selectedSlots: () => null,
          bookings: updatedBookings,
          // activeBooking: () => null,
        ),
      );
    } catch (e) {
      print('Error cancelling booking $e');
    }
  }

  Future<void> bookedStage(String bookingId, BookingModel booking) async {
    final List<BookingModel> bookings = List.from(state.bookings ?? []);
    bookings.add(booking);

    emit(
      state.copyWith(
        // stage: () => ReservationStage.booked,
        bookings: bookings,
        // isBooked: true,
      ),
    );

    // await updateBookingUseCase.execute(bookingId, booking.status);
  }

  Future<void> chargingStage() async {
    emit(
      state.copyWith(
        // stage: () => ReservationStage.charging,
        // isBooked: true,
      ),
    );
  }

  Future<void> publicChargerStage() async {
    emit(
      state.copyWith(
        // stage: () => ReservationStage.publicCharger,
        // isBooked: false,
      ),
    );
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
