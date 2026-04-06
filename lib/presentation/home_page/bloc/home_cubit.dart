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
import 'package:watt/presentation/home_page/view/sub_pages/stages/reservation_requested_widget.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

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

  HomeCubit({required this.authBloc})
    : super(HomeState(isUserAuthenticated: true, isLoading: true)) {
    authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthSuccessState) {
        emit(state.copyWith(isUserAuthenticated: true));
      } else if (authState is AuthUnauthenticatedState) {
        emit(state.copyWith(isUserAuthenticated: false));
      }
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }

  Future<void> getLocationPermission() async {
    try {
      final hasPermission = await getLocationPermissionUseCase.execute();
      if (hasPermission) {
        emit(state.copyWith(isLocationEnabled: true, isLoading: false));
      } else {
        emit(
          state.copyWith(
            errorMessage: 'Location is not enabled',
            isLocationEnabled: false,
            isLoading: true,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
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
            errorMessage: 'Location permission not granted',
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
            errorMessage: 'Could not get location',
            isLoading: true,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
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

      if (chargingStationsOnMap.isNotEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            chargingStationsOnMap: chargingStationsOnMap,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: 'No charging stations found',
            isLoading: true,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
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
              errorMessage: 'Location permission not granted',
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
            errorMessage: 'Could not get location',
            isLoading: true,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
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
          errorMessage: e.toString(),
          isLoading: false,
          clearUserData: true,
        ),
      );
    }
  }

  Future<void> bookingStage() async {
    emit(
      state.copyWith(
        stage: ReservationStage.booking,
      ),
    );
  }

  void toggleSlot(String slot) {
    final newSet = Set<String>.from(state.selectedSlots);

    if (newSet.contains(slot)) {
      newSet.remove(slot);
    } else {
      newSet.add(slot);
    }

    emit(state.copyWith(selectedSlots: newSet, errorTimeNotChosen: () => null));
  }

  Future<void> timeIsNotChosen() async {
    if (state.selectedSlots.isEmpty) {
      emit(
        state.copyWith(
          stage: ReservationStage.booking,
          errorTimeNotChosen: () => "The time wasn't chosen!",
        ),
      );
    } else {
      emit(
        state.copyWith(
          errorTimeNotChosen: null,
        ),
      );
    }
  }

  Future<void> reservationRequestedStage(BookingModel booking) async {
    await addBookingUseCase.execute(booking);

    final List<BookingModel> bookings = [];
    bookings.add(booking);

    emit(
      state.copyWith(
        stage: ReservationStage.reservationRequested,
        errorTimeNotChosen: null,
        bookings: bookings,
      ),
    );
  }

  Future<void> bookedStage(String bookingId, BookingModel booking) async {
    await updateBookingUseCase.execute(bookingId, booking.status);

    final List<BookingModel> bookings = [];
    bookings.add(booking);

    emit(
      state.copyWith(
        stage: ReservationStage.booked,
        bookings: bookings,
      ),
    );
  }

  Future<void> chargingStage() async {
    emit(
      state.copyWith(
        stage: ReservationStage.charging,
      ),
    );
  }

  Future<void> publicChargerStage() async {
    emit(
      state.copyWith(
        stage: ReservationStage.publicCharger,
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
