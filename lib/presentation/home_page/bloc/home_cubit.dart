import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;
  final ProfileCubit profileCubit;
  late StreamSubscription profileSubscription;

  final FetchAddedByUsersMockedChargingStationsUseCase
  fetchAddedByUsersMockedChargingStationsUseCase =
      FetchAddedByUsersMockedChargingStationsUseCase();
  final FetchPublicMockedChargingStationsUseCase
  fetchPublicMockedChargingStationsUseCase =
      FetchPublicMockedChargingStationsUseCase();
  final GetLocationPermissionUseCase getLocationPermissionUseCase =
      GetLocationPermissionUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final GetDistanceToUseCase getDistanceToUseCase = GetDistanceToUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();
  final AddBookingUseCase addBookingUseCase = AddBookingUseCase();
  final UpdateBookingUseCase updateBookingUseCase = UpdateBookingUseCase();
  final DeleteBookingUseCase deleteBookingUseCase = DeleteBookingUseCase();

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

  Future<void> fetchMockedChargingStations() async {
    try {
      final addedByUsersChargingStations =
          await fetchAddedByUsersMockedChargingStationsUseCase.execute();
      final publicChargingStations =
          await fetchPublicMockedChargingStationsUseCase.execute();
      final List<ChargingStationModel> chargingStationsOnMap = [];
      chargingStationsOnMap.addAll(addedByUsersChargingStations);
      chargingStationsOnMap.addAll(publicChargingStations);

      emit(
        state.copyWith(
          isLoading: false,
          chargingStationsOnMap: chargingStationsOnMap,
          errorMessage: () =>
              chargingStationsOnMap.isEmpty ? 'No stations found' : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString(), isLoading: false));
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

      if (position != null) {
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

  // Future<void> bookingStage() async {
  //   emit(
  //     state.copyWith(
  //       // stage: () => ReservationStage.booking,
  //       // selectedSlots: () => <String>{},
  //       // isBooked: false,
  //     ),
  //   );
  // }

  void toggleSlot(String slot) {
    final newSet = Set<String>.from(state.selectedSlots);

    if (newSet.contains(slot)) {
      newSet.remove(slot);
    } else {
      newSet.add(slot);
    }

    emit(
      state.copyWith(
        selectedSlots: () => newSet,
        errorTimeNotChosen: () => null,
      ),
    );
  }

  Future<void> timeIsNotChosen() async {
    if (state.selectedSlots.isEmpty) {
      emit(
        state.copyWith(
          // stage: () => ReservationStage.booking,
          // isBooked: false,
          errorTimeNotChosen: () => "The time wasn't chosen!",
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorTimeNotChosen: null,
          // isBooked: false,
        ),
      );
    }
  }

  // Future<void> generateUuid(String id) async {
  //   emit(
  //     state.copyWith(
  //       activeBookingId: () => id,
  //     ),
  //   );
  // }

  Future<void> reservationRequestedStage(BookingModel booking) async {
    try {
      await addBookingUseCase.execute(booking);

      final List<BookingModel> updatedBookings = List.from(
        state.bookings ?? [],
      );

      updatedBookings.add(booking);

      emit(
        state.copyWith(
          // activeBooking: () => booking,
          bookings: updatedBookings,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> clearBookingState() async {
    try {
      emit(
        state.copyWith(
          selectedSlots: () => <String>{},
        ),
      );
    } catch (e) {
      print("Can't be cleared $e");
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    for (final booking in (state.bookings ?? [])) {
      if (booking.id == bookingId) {
        print(booking.id);
        print(bookingId);
      }
    }

    final updatedBookings = (state.bookings ?? [])
        .where((b) => b.id != bookingId)
        .toList();

    emit(
      state.copyWith(
        selectedSlots: () => <String>{},
        bookings: updatedBookings,
        // activeBooking: () => null,
      ),
    );

    try {
      await deleteBookingUseCase.execute(bookingId);
      // await fetchUserData();
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

    await updateBookingUseCase.execute(bookingId, booking.status);
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

  // Future<void> fetchUserData() async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final user = await getUserDataUseCase.execute();
  //     if (user != null) {
  //       emit(
  //         state.copyWith(
  //           userData: user,
  //           isLoading: false,
  //           isUserAuthenticated: true,
  //         ),
  //       );
  //     } else {
  //       emit(
  //         state.copyWith(
  //           isLoading: false,
  //           isUserAuthenticated: false,
  //           clearUserData: true,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.toString(),
  //         isLoading: false,
  //         clearUserData: true,
  //       ),
  //     );
  //   }
  // }

  // Future<Position?> goToMyLocation() async {
  //   try {
  //     final Position? position = await goToMyLocationUseCase.execute();
  //
  //     if (position != null) {
  //       final String address =
  //       await GoogleMapsHelperMethods.convertPositionToAddress(position);
  //       print("Position: $position");
  //       print("Position: $address");
  //       emit(
  //         state.copyWith(
  //           address: () => address,
  //           addressPosition: () => position,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  //   try {
  //     final myLocation = await goToMyLocationUseCase.execute();
  //     emit(state.copyWith(myLocation: myLocation));
  //   } catch (e) {
  //     emit(state.copyWith(errorMessage: e.toString()));
  //   }
  // }

  // on<GoToMyLocationEvent>((event, emit) async {
  // try {
  // final Position? position = await goToMyLocationUseCase.execute();
  //
  // if (position != null) {
  // final String address =
  // await GoogleMapsHelperMethods.convertPositionToAddress(position);
  // print("Position: $position");
  // print("Position: $address");
  // emit(
  // state.copyWith(
  // address: () => address,
  // addressPosition: () => position,
  // ),
  // );
  // }
  // } catch (e) {
  // print("Error: $e");
  // }
  // });

  // Future<void> getDistanceToLocation(
  //   double targetLatitude,
  //   double targetLongitude,
  // ) async {
  //   try {
  //     final Position? position = await goToMyLocationUseCase.execute();
  //     final distanceToLocation = await getDistanceToUseCase.execute(
  //       position,
  //       targetLatitude,
  //       targetLongitude,
  //     );
  //     emit(state.copyWith(distanceToLocation: distanceToLocation));
  //   } catch (e) {
  //     emit(state.copyWith(errorMessage: e.toString()));
  //   }
  // }
}
