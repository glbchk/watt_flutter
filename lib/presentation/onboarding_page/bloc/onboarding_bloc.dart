import 'package:bloc/bloc.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdateUserPhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdateUserPhoneNumberUseCase();
  final UpdateUserCarUseCase updateUserCarUseCase = UpdateUserCarUseCase();
  final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  final UpdatePlateNumberCarsUseCase updatePlateNumberCarUseCase =
      UpdatePlateNumberCarsUseCase();
  final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  final FetchUserChargingStationsUseCase fetchUserChargingStationsUseCase =
      FetchUserChargingStationsUseCase();

  OnboardingBloc() : super(OnboardingState()) {
    on<NameVerificationEvent>((event, emit) {
      if (event.value.length < 3) {
        emit(
          state.copyWith(
            nameError: () => 'Name should be at least 3 symbols',
            isNameValid: () => false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            name: () => event.value,
            nameError: () => null,
            isNameValid: () => true,
          ),
        );
      }
    });

    on<PhoneNumberVerificationEvent>((event, emit) {
      if (event.value.length < 11) {
        emit(
          state.copyWith(
            phoneNumberError: () => 'Phone number must contain 9 digits',
            isPhoneNumberValid: () => false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            phoneNumber: () => event.value,
            phoneNumberError: () => null,
            isPhoneNumberValid: () => true,
          ),
        );
      }
    });

    on<OnboardingFilledNamePhoneNumberEvent>((event, emit) async {
      await updateUserNameUseCase.execute(
        event.name,
      );
      await updateUserPhoneNumberUseCase.execute(
        event.phoneNumber,
      );
      emit(
        state.copyWith(
          name: () => event.name,
          phoneNumber: () => event.phoneNumber,
        ),
      );
    });

    on<OnboardingFilledCarModelEvent>((event, emit) async {
      await updateUserCarUseCase.execute(
        event.car,
      );

      final List<CarModel> updateCarsList = [...?state.cars, event.car];

      emit(
        state.copyWith(
          cars: () => updateCarsList,
        ),
      );
    });

    on<FetchUserCarsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<CarModel> cars = await fetchUserCarsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            cars: () => cars,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<UpdatePlateNumberCarEvent>((event, emit) async {
      await updatePlateNumberCarUseCase.execute(
        event.carId,
        event.plateNumber,
      );

      final List<CarModel> updatedCarsList = (state.cars ?? []).map((car) {
        return car.id == event.carId
            ? car.copyCarWith(plateNumber: event.plateNumber)
            : car;
      }).toList();

      emit(
        state.copyWith(
          cars: () => updatedCarsList,
        ),
      );
    });

    on<DeleteCarEvent>((event, emit) async {
      await deleteCarUseCase.execute(
        event.carId,
      );

      final updatedCarsList = (state.cars ?? [])
          .where((car) => car.id != event.carId)
          .toList();

      emit(
        state.copyWith(
          cars: () => updatedCarsList,
        ),
      );
    });

    on<FetchUserChargingStationsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<ChargingStationModel> chargingStations =
            await fetchUserChargingStationsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            chargingStations: () => chargingStations,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
