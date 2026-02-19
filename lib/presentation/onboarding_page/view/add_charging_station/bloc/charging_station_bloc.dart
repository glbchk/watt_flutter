import 'package:bloc/bloc.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/details_page.dart';

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

    on<UpdateChargingStationPropertyEvent>((event, emit) {
      emit(
        switch (event.property) {
          DetailPageProperties.chargingStationName => state.copyWith(
            chargingStationName: () => event.value,
          ),

          DetailPageProperties.address => state.copyWith(
            address: () => event.value,
          ),

          DetailPageProperties.brandName => state.copyWith(
            brandName: () => event.value,
          ),

          DetailPageProperties.chargingEffect => state.copyWith(
            chargingEffect: () => event.value,
          ),

          DetailPageProperties.plug => state.copyWith(plug: () => event.value),

          DetailPageProperties.pricePerKwh => state.copyWith(
            pricePerKwh: () => event.value,
          ),

          DetailPageProperties.bankAccount => state.copyWith(
            bankAccount: () => event.value,
          ),

          DetailPageProperties.availableHours => state,
        },
      );
    });
    on<AddChargingStationEvent>((event, emit) async {
      await addChargingStationUseCase.execute(event.chargingStation);
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
