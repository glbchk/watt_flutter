import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

class MyChargingStationsCubit extends Cubit<MyChargingStationsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final FetchMockedChargingStationOptionsUseCase
  fetchMockedChargingStationOptionsUseCase =
      FetchMockedChargingStationOptionsUseCase();
  final FetchMockedChargingEffectOptionsUseCase
  fetchMockedChargingEffectOptionsUseCase =
      FetchMockedChargingEffectOptionsUseCase();
  final FetchMockedPlugOptionsUseCase fetchMockedPlugOptionsUseCase =
      FetchMockedPlugOptionsUseCase();
  final FetchLocationSuggestionsUseCase fetchLocationSuggestionsUseCase =
      FetchLocationSuggestionsUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final SearchLocationUseCase searchLocationUseCase = SearchLocationUseCase();
  final HandleMapTapUseCase handleMapTapUseCase = HandleMapTapUseCase();
  final ChooseLocationOnMapUseCase chooseLocationOnMapUseCase =
      ChooseLocationOnMapUseCase();
  // final AddCarUseCase updateUserCarUseCase = AddCarUseCase();
  // final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  // final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  // final FetchUserCarsUseCase getUserCarsUseCase = FetchUserCarsUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();

  MyChargingStationsCubit({required this.authBloc})
    : super(
        MyChargingStationsState(isUserAuthenticated: true, isLoading: true),
      ) {
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

  Future<void> fetchMockedChargingStationOptionsData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final List<MockedChargingStationOption> chargingStationOptions =
          await fetchMockedChargingStationOptionsUseCase.execute();

      emit(
        state.copyWith(
          isLoading: false,
          chargingStationOptions: chargingStationOptions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> fetchMockedChargingEffectOptionsData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final List<String> chargingEffectOptions =
          await fetchMockedChargingEffectOptionsUseCase.execute();

      emit(
        state.copyWith(
          isLoading: false,
          chargingEffectOptions: chargingEffectOptions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> fetchMockedPlugOptionsData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final List<String> plugOptions = await fetchMockedPlugOptionsUseCase
          .execute();

      emit(
        state.copyWith(
          isLoading: false,
          plugOptions: plugOptions,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> saveBrandAndLogoChargingStation(
    String brandName,
    String brandLogo,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final ChargingStationModel chargingStationInitiated =
          ChargingStationModel(
            id: Uuid().v4(),
            brandName: brandName,
            brandLogo: brandLogo,
          );

      emit(
        state.copyWith(
          chargingStation: chargingStationInitiated,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error initializing charging station: $e');
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  void saveChargingStationName(
    String stationName,
  ) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          chargingStationName: stationName,
        ),
      ),
    );
  }

  Future<void> fetchLocationSuggestions(String location) async {
    try {
      final List<String> suggestions = await fetchLocationSuggestionsUseCase
          .execute(location);

      emit(
        state.copyWith(
          locationSuggestions: suggestions,
        ),
      );
    } catch (e) {
      print("Error fetching suggestion locations: $e");
    }
  }

  Future<void> goToMyLocation() async {
    try {
      final Position? position = await goToMyLocationUseCase.execute();

      if (position != null) {
        final String address =
            await GoogleMapsHelperMethods.convertPositionToAddress(position);
        print("Position: $position");
        print("Position: $address");
        emit(
          state.copyWith(
            chargingStation: state.chargingStation?.copyChargingStationWith(
              address: address,
              addressLatitude: position.latitude,
              addressLongitude: position.longitude,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> searchMyLocation(
    String address,
    GoogleMapController? mapController,
  ) async {
    try {
      final LocationResult? locationResult = await searchLocationUseCase
          .execute(
            address,
            mapController,
          );

      print("Position: ${locationResult?.position}");
      emit(
        state.copyWith(
          chargingStation: state.chargingStation?.copyChargingStationWith(
            address: locationResult?.address,
            addressLatitude: locationResult?.position.latitude,
            addressLongitude: locationResult?.position.longitude,
          ),
        ),
      );
    } catch (e) {
      print("Not possible to find address: $e");
    }
  }

  Future<void> handleMapTap(LatLng tappedPoint) async {
    try {
      print('mapController result: ${tappedPoint}');

      final String? tapResult = await handleMapTapUseCase.execute(
        tappedPoint,
      );

      final Position? addressPosition =
          await GoogleMapsHelperMethods.convertAddressToPosition(
            tapResult ?? '',
          );
      emit(
        state.copyWith(
          chargingStation: state.chargingStation?.copyChargingStationWith(
            address: tapResult,
            addressLatitude: addressPosition?.latitude,
            addressLongitude: addressPosition?.longitude,
          ),
        ),
      );
    } catch (e) {
      print("Not possible to find address: $e");
    }
  }

  Future<void> chooseLocationOnMap() async {
    try {
      final LocationResult? locationResult = await chooseLocationOnMapUseCase
          .execute();

      emit(
        state.copyWith(
          chargingStation: state.chargingStation?.copyChargingStationWith(
            address: locationResult?.address,
            addressLatitude: locationResult?.position.latitude,
            addressLongitude: locationResult?.position.longitude,
          ),
        ),
      );
    } catch (e) {
      print("Not possible to find address: $e");
    }
  }

  void saveAddress(
    String address,
    double? addressLatitude,
    double? addressLongitude,
  ) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          address: address,
          addressLatitude: addressLatitude,
          addressLongitude: addressLongitude,
        ),
      ),
    );
  }

  void clearAddress() {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          address: '',
          addressLatitude: null,
          addressLongitude: null,
        ),
        locationSuggestions: [],
      ),
    );
  }

  void saveChargingStationBrand(
    String brandName,
    String brandLogo,
  ) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          brandName: brandName,
          brandLogo: brandLogo,
        ),
      ),
    );
  }

  void saveChargingEffect(String chargingEffect) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          chargingEffect: chargingEffect,
        ),
      ),
    );
  }

  void savePlug(String plug) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          plug: plug,
        ),
      ),
    );
  }

  void savePrice(String price) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          pricePerKwh: price,
        ),
      ),
    );
  }

  void verifyIban(String value) {
    String? ibanError;

    if (value.isEmpty) {
      ibanError = 'Please enter an IBAN number.';
    } else if (value.length < 15) {
      ibanError = 'This IBAN is too short. Please check the number.';
    } else if (value.length > 34) {
      ibanError = 'This IBAN is too long. Please check the number.';
    }

    emit(
      state.copyWith(
        ibanError: () => ibanError,
      ),
    );
  }

  void saveIban(IbanModel iban) {
    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          bankAccount: iban,
        ),
      ),
    );
  }

  void removeIban() {
    final IbanModel clearIban = IbanModel(
      id: '',
      isUsedForReceivingEarnings: false,
    );

    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          bankAccount: clearIban,
        ),
      ),
    );
  }

  void verifyAvailableHours(
    List<int> availableDays,
    String startTime,
    String endTime,
  ) {
    String? daysError;
    String? startError;
    String? endError;

    if (availableDays.isEmpty) {
      daysError = 'At least one day should be added.';
    }

    if (startTime.isEmpty) {
      startError = 'Start time should be selected.';
    }

    if (endTime.isEmpty) {
      endError = 'End time should be selected.';
    }

    emit(
      state.copyWith(
        availableDaysError: () => daysError,
        startTimeError: () => startError,
        endTimeError: () => endError,
      ),
    );
  }

  void addTimeSlot(TimeSlotModel timeSlot) {
    final List<TimeSlotModel> updatedTimeSlots = [
      ...?state.chargingStation?.availableHours,
      timeSlot,
    ];

    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          availableHours: updatedTimeSlots,
        ),
      ),
    );
  }

  void removeTimeSlot(String timeSlotId) {
    final List<TimeSlotModel>? updatedList = state
        .chargingStation
        ?.availableHours!
        .where((slot) => slot.id != timeSlotId)
        .toList();

    emit(
      state.copyWith(
        chargingStation: state.chargingStation?.copyChargingStationWith(
          availableHours: updatedList,
        ),
      ),
    );
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
}
