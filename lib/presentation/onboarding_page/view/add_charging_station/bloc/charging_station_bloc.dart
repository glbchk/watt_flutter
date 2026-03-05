import 'package:bloc/bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';

class ChargingStationBloc
    extends Bloc<ChargingStationEvent, ChargingStationState> {
  final AddChargingStationUseCase addChargingStationUseCase =
      AddChargingStationUseCase();
  // final FetchUserChargingStationsUseCase fetchUserChargingStationsUseCase =
  //     FetchUserChargingStationsUseCase();
  ChargingStationBloc() : super(ChargingStationState()) {
    on<SaveBrandNameChargingStationEvent>((event, emit) {
      emit(
        state.copyWith(
          brandName: () => event.brandName,
          brandLogo: () => event.brandLogo,
        ),
      );
    });

    // on<SaveAddressChargingStationEvent>((event, emit) {
    //   emit(
    //     state.copyWith(
    //       address: () => event.address,
    //     ),
    //   );
    // });

    on<SaveNamePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingStationName: () => event.value,
        ),
      );
    });

    on<SaveAddressPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          address: () => event.value,
        ),
      );
    });

    on<UpdateBrandNamePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          brandName: () => event.value,
          brandLogo: () => event.brandLogo,
        ),
      );
    });

    on<SaveChargingEffectPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          chargingEffect: () => event.value,
        ),
      );
    });

    on<SavePlugPropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          plug: () => event.value,
        ),
      );
    });

    on<SavePricePropertyEvent>((event, emit) {
      emit(
        state.copyWith(
          pricePerKwh: () => event.value,
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
          bankAccounts: () => paymentMethods,
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
          availableHours: () => updatedTimeSlots,
        ),
      );
    });

    on<AddChargingStationEvent>((event, emit) async {
      await addChargingStationUseCase.execute(event.chargingStation);
      final List<ChargingStationModel> chargingStationsUpdated = [
        ...?state.chargingStations,
        event.chargingStation,
      ];

      emit(
        state.copyWith(
          chargingStations: () => chargingStationsUpdated,
        ),
      );

      emit(const ChargingStationState());
    });

    on<ResetChargingStationFormEvent>((event, emit) {
      emit(const ChargingStationState());
    });

    // on<UpdateChargingStationEvent>((event, emit) async {
    //   await updatePlateNumberCarUseCase.execute(
    //     event.chargingStationId,
    //   );
    //
    //   final List<ChargingStationModel> updatedCarsList =
    //       (state.chargingStations ?? []).map((chargingStation) {
    //         return chargingStation.id == event.carId
    //             ? car.copyCarWith(plateNumber: event.plateNumber)
    //             : car;
    //       }).toList();
    //
    //   emit(
    //     state.copyWith(
    //       cars: () => updatedCarsList,
    //     ),
    //   );
    // });

    // on<OnboardingFilledChargingStationEvent>((event, emit) async {
    //   await updateUserChargingStationUseCase.execute(
    //     event.chargingStation,
    //   );

    //   final List<ChargingStationModel> updateChargingStationsList = [
    //     ...?state.chargingStations,
    //     event.chargingStation,
    //   ];
    //
    //   emit(
    //     state.copyWith(
    //       chargingStations: () => updateChargingStationsList,
    //     ),
    //   );
    // });
    //
    // on<FetchUserChargingStationsEvent>((event, emit) async {
    //   emit(state.copyWith(isLoading: true));
    //
    //   try {
    //     final List<ChargingStationModel> chargingStations =
    //         await fetchUserChargingStationsUseCase.execute();
    //
    //     emit(
    //       state.copyWith(
    //         isLoading: false,
    //         chargingStations: () => chargingStations,
    //       ),
    //     );
    //   } catch (e) {
    //     emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    //   }
    // });
  }
}
