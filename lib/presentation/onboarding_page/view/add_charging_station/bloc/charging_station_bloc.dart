import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

class ChargingStationBloc
    extends Bloc<ChargingStationEvent, ChargingStationState> {
  final FetchMockedChargingStationOptionsUseCase
  fetchMockedChargingStationOptionsUseCase =
      FetchMockedChargingStationOptionsUseCase();
  final FetchLocationSuggestionsUseCase fetchLocationSuggestionsUseCase =
      FetchLocationSuggestionsUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final SearchLocationUseCase searchLocationUseCase = SearchLocationUseCase();
  final HandleMapTapUseCase handleMapTapUseCase = HandleMapTapUseCase();
  final ChooseLocationOnMapUseCase chooseLocationOnMapUseCase =
      ChooseLocationOnMapUseCase();
  final FetchMockedChargingEffectOptionsUseCase
  fetchMockedChargingEffectOptionsUseCase =
      FetchMockedChargingEffectOptionsUseCase();
  final FetchMockedPlugOptionsUseCase fetchMockedPlugOptionsUseCase =
      FetchMockedPlugOptionsUseCase();

  ChargingStationBloc() : super(ChargingStationState()) {
    on<FetchMockedChargingStationOptionsEvent>((event, emit) async {
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
    });

    on<SaveBrandNameChargingStationEvent>((event, emit) {
      emit(
        state.copyWith(
          errorMessage: null,
          id: null,
          chargingStationName: "",
          address: () => null,
          addressLatitude: () => null,
          addressLongitude: () => null,
          locationSuggestions: [],
          brandName: event.brandName,
          brandLogo: event.brandLogo,
          chargingEffect: "",
          plug: "",
          pricePerKwh: "",
          bankAccounts: [],
          onlineCharger: false,
          availableHours: [],
          everyoneCanAccess: false,
        ),
      );
    });

    on<SaveNamePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingStationName: event.value,
        ),
      );
    });

    on<GoToMyLocationEvent>((event, emit) async {
      try {
        final Position? position = await goToMyLocationUseCase.execute();

        if (position != null) {
          final String address =
              await GoogleMapsHelperMethods.convertPositionToAddress(position);
          print("Position: $position");
          print("Position: $address");
          emit(
            state.copyWith(
              address: () => address,
              addressLatitude: () => position.latitude,
              addressLongitude: () => position.longitude,
            ),
          );
        }
      } catch (e) {
        print("Error: $e");
      }
    });

    on<SearchLocationEvent>((event, emit) async {
      try {
        print('mapController is null: ${event.mapController == null}');

        final LocationResult? locationResult = await searchLocationUseCase
            .execute(
              event.address,
              event.mapController,
            );

        if (locationResult == null) {
          emit(
            state.copyWith(
              address: () => null,
              addressLatitude: () => null,
              addressLongitude: () => null,
            ),
          );
          return;
        } else {
          print("Position: ${locationResult.position}");
          emit(
            state.copyWith(
              address: () => locationResult.address,
              addressLatitude: () => locationResult.position.latitude,
              addressLongitude: () => locationResult.position.longitude,
            ),
          );
        }
      } catch (e) {
        print("Not possible to find address: $e");
      }
    });

    on<HandleMapTapEvent>((event, emit) async {
      try {
        print('mapController result: ${event.tappedPoint}');

        final String? tapResult = await handleMapTapUseCase.execute(
          event.tappedPoint,
        );

        if (tapResult == null) {
          emit(
            state.copyWith(
              address: () => null,
              addressLatitude: () => null,
              addressLongitude: () => null,
            ),
          );
          return;
        } else {
          final Position? addressPosition =
              await GoogleMapsHelperMethods.convertAddressToPosition(tapResult);
          emit(
            state.copyWith(
              address: () => tapResult,
              addressLatitude: () => addressPosition?.latitude,
              addressLongitude: () => addressPosition?.longitude,
            ),
          );
        }
      } catch (e) {
        print("Not possible to find address: $e");
      }
    });

    on<ChooseLocationOnMapEvent>((event, emit) async {
      try {
        final LocationResult? locationResult = await chooseLocationOnMapUseCase
            .execute();

        if (locationResult == null) {
          emit(
            state.copyWith(
              address: () => null,
              addressLatitude: () => null,
              addressLongitude: () => null,
            ),
          );
          return;
        } else {
          emit(
            state.copyWith(
              address: () => locationResult.address,
              addressLatitude: () => locationResult.position.latitude,
              addressLongitude: () => locationResult.position.longitude,
            ),
          );
        }
      } catch (e) {
        print("Not possible to find address: $e");
      }
    });

    on<FetchLocationSuggestionsEvent>((event, emit) async {
      try {
        final List<String> suggestions = await fetchLocationSuggestionsUseCase
            .execute(event.value);

        emit(
          state.copyWith(
            locationSuggestions: suggestions,
          ),
        );
      } catch (e) {
        print("Error: $e");
      }
    });

    on<SaveAddressPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          address: () => event.value,
          addressLatitude: () => event.addressLatitude,
          addressLongitude: () => event.addressLongitude,
        ),
      );
    });

    on<ClearAddressPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          address: () => null,
          addressLatitude: () => null,
          addressLongitude: () => null,
          locationSuggestions: [],
        ),
      );
    });

    on<UpdateBrandNamePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          brandName: event.value,
          brandLogo: event.brandLogo,
        ),
      );
    });

    on<FetchMockedChargingEffectOptionsEvent>((event, emit) async {
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
    });

    on<SaveChargingEffectPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingEffect: event.value,
        ),
      );
    });

    on<FetchMockedPlugOptionsEvent>((event, emit) async {
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
    });

    on<SavePlugPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          plug: event.value,
        ),
      );
    });

    on<SavePricePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          pricePerKwh: event.value,
        ),
      );
    });

    on<IbanVerificationEvent>((event, emit) {
      String? ibanError;

      if (event.value.isEmpty) {
        ibanError = 'Please enter an IBAN number.';
      } else if (event.value.length < 15) {
        ibanError = 'This IBAN is too short. Please check the number.';
      } else if (event.value.length > 34) {
        ibanError = 'This IBAN is too long. Please check the number.';
      }

      emit(
        state.copyWith(
          ibanError: () => ibanError,
        ),
      );
    });

    on<AddIbanEvent>((event, emit) {
      final List<IbanModel> paymentMethods = [
        ...?state.bankAccounts,
        event.iban,
      ];

      emit(
        state.copyWith(
          bankAccounts: paymentMethods,
          ibanError: () => null,
        ),
      );
    });

    on<RemoveIbanEvent>((event, emit) {
      final List<IbanModel> updatedList = state.bankAccounts!
          .where((bankAccount) => bankAccount.id != event.ibanId)
          .toList();

      emit(
        state.copyWith(
          bankAccounts: updatedList,
        ),
      );
    });

    on<AvailableHoursVerificationEvent>((event, emit) {
      String? daysError;
      String? startError;
      String? endError;

      if (event.availableDays.isEmpty) {
        daysError = 'At least one day should be added.';
      }

      if (event.startTime.isEmpty) {
        startError = 'Start time should be selected.';
      }

      if (event.endTime.isEmpty) {
        endError = 'End time should be selected.';
      }

      emit(
        state.copyWith(
          availableDaysError: () => daysError,
          startTimeError: () => startError,
          endTimeError: () => endError,
        ),
      );
    });

    on<AddTimeSlotEvent>((event, emit) {
      final List<TimeSlotModel> updatedTimeSlots = [
        ...?state.availableHours,
        event.timeSlot,
      ];

      emit(
        state.copyWith(
          availableHours: updatedTimeSlots,
        ),
      );
    });

    on<RemoveTimeSlotEvent>((event, emit) {
      final List<TimeSlotModel> updatedList = state.availableHours!
          .where((slot) => slot.id != event.timeSlotId)
          .toList();

      emit(
        state.copyWith(
          availableHours: updatedList,
        ),
      );
    });

    on<AddOneChargingStationEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingStation: event.chargingStation,
        ),
      );

      final List<ChargingStationModel> chargingStationsUpdated = [
        ...?state.chargingStations,
        event.chargingStation,
      ];

      emit(
        state.copyWith(
          chargingStations: chargingStationsUpdated,
        ),
      );
    });

    on<RemoveChargingStationEvent>((event, emit) {
      final List<ChargingStationModel> updatedList = state.chargingStations!
          .where((station) => station.id != event.chargingStationId)
          .toList();

      emit(
        state.copyWith(
          chargingStations: updatedList,
        ),
      );
    });
  }
}
