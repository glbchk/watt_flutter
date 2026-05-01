import 'package:bloc/bloc.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UpdateUserNameUseCase updateUserNameUseCase = UpdateUserNameUseCase();
  final UpdatePhoneNumberUseCase updateUserPhoneNumberUseCase =
      UpdatePhoneNumberUseCase();
  final FetchMockedCarOptionsUseCase fetchMockedCarOptionsUseCase =
      FetchMockedCarOptionsUseCase();
  final FetchMockedCarModelOptionsUseCase fetchMockedCarModelOptionsUseCase =
      FetchMockedCarModelOptionsUseCase();
  final AddCarUseCase updateUserCarUseCase = AddCarUseCase();
  final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  final UpdatePlateNumberCarsUseCase updatePlateNumberCarUseCase =
      UpdatePlateNumberCarsUseCase();
  final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  final AddChargingStationsUseCase addChargingStationsUseCase =
      AddChargingStationsUseCase();
  // final SyncStationToGlobalUseCase syncStationToGlobalUseCase =
  //     SyncStationToGlobalUseCase();
  final FetchUserChargingStationsUseCase fetchUserChargingStationsUseCase =
      FetchUserChargingStationsUseCase();
  final FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();

  OnboardingBloc() : super(OnboardingState()) {
    on<NameVerificationEvent>((event, emit) {
      final validationError = StringHelperMethods.validateMinLength(
        value: event.value,
        minLength: 3,
        errorMessage: 'Name should be at least 3 symbols',
      );

      print(validationError);
      emit(
        state.copyWith(
          nameError: validationError ?? "",
          isNameValid: event.value.length >= 3,
        ),
      );
    });

    on<PhoneNumberVerificationEvent>((event, emit) {
      final digits = event.value.replaceAll(RegExp(r'\D'), '');
      final validationError = StringHelperMethods.validateMinLength(
        value: digits,
        minLength: 10,
        errorMessage: 'Phone number must contain 10 digits',
      );

      print("Phone number error: $validationError");

      emit(
        state.copyWith(
          phoneNumberError: validationError ?? "",
          isPhoneNumberValid: event.value.length >= 10,
        ),
      );
    });

    on<OnboardingFilledNamePhoneNumberEvent>((event, emit) async {
      try {
        if (event.name.isNotEmpty) {
          await updateUserNameUseCase.execute(
            event.name,
          );
        }
        if (event.phoneNumber.isNotEmpty) {
          await updateUserPhoneNumberUseCase.execute(
            event.phoneNumber,
          );
        }
        emit(
          state.copyWith(
            name: event.name,
            phoneNumber: event.phoneNumber,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<FetchMockedCarOptionsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<MockedCarOption> carOptions =
            await fetchMockedCarOptionsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            carOptions: carOptions,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<FetchMockedCarModelOptionsEvent>((event, emit) async {
      try {
        final Map<MockedCarBrand, List<String>> carModelOptions =
            await fetchMockedCarModelOptionsUseCase.execute();

        emit(
          state.copyWith(
            carModelOptions: carModelOptions,
          ),
        );
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    });

    on<OnboardingFilledCarModelEvent>((event, emit) async {
      try {
        await updateUserCarUseCase.execute(
          event.car,
        );

        final List<CarModel> updateCarsList = [...?state.cars, event.car];

        emit(
          state.copyWith(
            cars: updateCarsList,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<FetchUserCarsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<CarModel> cars = await fetchUserCarsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            cars: cars,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<UpdatePlateNumberCarEvent>((event, emit) async {
      try {
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
            cars: updatedCarsList,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<DeleteCarEvent>((event, emit) async {
      try {
        await deleteCarUseCase.execute(
          event.carId,
        );

        final updatedCarsList = (state.cars ?? [])
            .where((car) => car.id != event.carId)
            .toList();

        emit(
          state.copyWith(
            cars: updatedCarsList,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<FetchUserChargingStationsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final List<ChargingStationModel> chargingStations =
            await fetchUserChargingStationsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            chargingStations: chargingStations,
          ),
        );
      } catch (e) {
        print('Error fetching charging stations: $e');
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<AddedChargingStationsEvent>((event, emit) async {
      try {
        await addChargingStationsUseCase.execute(event.chargingStations);
        final List<ChargingStationModel> chargingStations =
            event.chargingStations;

        emit(
          state.copyWith(
            chargingStations: chargingStations,
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
        final List<CreditCardModel> paymentMethods =
            await fetchPaymentMethodsUseCase.execute();

        emit(
          state.copyWith(
            isLoading: false,
            paymentMethods: paymentMethods,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
