import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watt/data/data_sources/google_maps_data_source.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/domain/use_cases/get_google_maps_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

class ChargingStationBloc
    extends Bloc<ChargingStationEvent, ChargingStationState> {
  // final FetchUserChargingStationsUseCase fetchUserChargingStationsUseCase =
  //     FetchUserChargingStationsUseCase();
  final FetchLocationSuggestionsUseCase fetchLocationSuggestionsUseCase =
      FetchLocationSuggestionsUseCase();
  final GoToMyLocationUseCase goToMyLocationUseCase = GoToMyLocationUseCase();
  final SearchLocationUseCase searchLocationUseCase = SearchLocationUseCase();

  ChargingStationBloc() : super(ChargingStationState()) {
    on<SaveBrandNameChargingStationEvent>((event, emit) {
      emit(
        state.copyWith(
          brandName: event.brandName,
          brandLogo: event.brandLogo,
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
              address: address,
              addressPosition: position,
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
              // event.onLocationFound,
            );

        if (locationResult == null) {
          emit(
            state.copyWith(
              address: null,
              addressPosition: null,
            ),
          );
          return;
        } else {
          print("Position: ${locationResult.position}");
          emit(
            state.copyWith(
              address: locationResult.address,
              addressPosition: locationResult.position,
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
          address: event.value,
          addressPosition: event.addressPosition,
        ),
      );
    });

    on<ClearAddressPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          address: null,
          addressPosition: null,
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

    on<SaveChargingEffectPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingEffect: event.value,
        ),
      );
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

    on<AddIbanEvent>((event, emit) {
      final List<IbanModel> paymentMethods = [
        ...?state.bankAccounts,
        event.iban,
      ];

      emit(
        state.copyWith(
          bankAccounts: paymentMethods,
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

    on<ResetChargingStationFormEvent>((event, emit) {
      emit(
        state.copyWith(
          errorMessage: null,
          id: null,
          chargingStationName: null,
          address: null,
          chargingEffect: null,
          plug: null,
          pricePerKwh: null,
          bankAccounts: null,
          onlineCharger: false,
          availableHours: null,
          everyoneCanAccess: false,
        ),
      );
    });
  }
}
