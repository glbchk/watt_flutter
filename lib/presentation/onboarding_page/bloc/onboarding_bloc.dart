import 'package:bloc/bloc.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdatePhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdatePhoneNumberUseCase();
  final AddCarUseCase updateUserCarUseCase = AddCarUseCase();
  final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  final UpdatePlateNumberCarsUseCase updatePlateNumberCarUseCase =
      UpdatePlateNumberCarsUseCase();
  final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  final AddChargingStationsUseCase addChargingStationsUseCase =
      AddChargingStationsUseCase();
  final FetchUserChargingStationsUseCase fetchUserChargingStationsUseCase =
      FetchUserChargingStationsUseCase();
  final FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();

  String? _validateMinLength({
    required String value,
    required int minLength,
    required String errorMessage,
  }) {
    if (value.isEmpty) return null;
    if (value.length < minLength) return errorMessage;
    return null;
  }

  OnboardingBloc() : super(OnboardingState()) {
    on<NameVerificationEvent>((event, emit) {
      emit(
        state.copyWith(
          nameError: () => _validateMinLength(
            value: event.value,
            minLength: 3,
            errorMessage: 'Name should be at least 3 symbols',
          ),
          isNameValid: () =>
              (event.value == null || event.value.length < 3) ? false : true,
        ),
      );
    });

    on<PhoneNumberVerificationEvent>((event, emit) {
      final digits = event.value.replaceAll(RegExp(r'\D'), '');

      emit(
        state.copyWith(
          phoneNumberError: () => _validateMinLength(
            value: digits,
            minLength: 10,
            errorMessage: 'Phone number must contain 10 digits',
          ),
          isPhoneNumberValid: () =>
              (event.value == null || digits.length < 10) ? false : true,
        ),
      );
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
        print('Error fetching charging stations: $e');
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<AddedChargingStationsEvent>((event, emit) async {
      await addChargingStationsUseCase.execute(event.chargingStations);
      try {
        final List<ChargingStationModel> chargingStations =
            event.chargingStations;

        emit(
          state.copyWith(
            chargingStations: () => chargingStations,
          ),
        );
      } catch (e) {
        print('Error adding charging station: $e');
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<FetchUserPaymentMethodsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<PaymentMethodModel> paymentMethods =
            await fetchPaymentMethodsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            paymentMethods: () => paymentMethods,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
