import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/settings_pages/cars_page/bloc/my_cars_state.dart';

class MyCarsCubit extends Cubit<MyCarsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final FetchMockedCarOptionsUseCase fetchMockedCarOptionsUseCase =
      FetchMockedCarOptionsUseCase();
  final FetchMockedCarModelOptionsUseCase fetchMockedCarModelOptionsUseCase =
      FetchMockedCarModelOptionsUseCase();
  final AddCarUseCase updateUserCarUseCase = AddCarUseCase();
  final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  final FetchUserCarsUseCase getUserCarsUseCase = FetchUserCarsUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();

  MyCarsCubit({required this.authBloc})
    : super(MyCarsState(isUserAuthenticated: true, isLoading: true)) {
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

  Future<void> fetchMockedCarOptionsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<MockedCarOption> carOptions =
          await fetchMockedCarOptionsUseCase.execute();
      print('User cars fetched successfully: $carOptions');
      emit(
        state.copyWith(
          carOptions: carOptions,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error fetching user cars: $e');
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> fetchMockedCarModelsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final Map<MockedCarBrand, List<String>> carModelOptions =
          await fetchMockedCarModelOptionsUseCase.execute();

      emit(
        state.copyWith(
          carModelOptions: carModelOptions,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }

  Future<void> saveNewCar(CarModel car) async {
    emit(state.copyWith(isLoading: true));
    try {
      await updateUserCarUseCase.execute(car);

      final List<CarModel> updateCarsList = [...?state.userCars, car];

      emit(
        state.copyWith(
          userCars: updateCarsList,
          isLoading: false,
        ),
      );
    } catch (e) {
      print('Error adding car: $e');
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> deleteCar(String carId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedCarsList = (state.userCars ?? [])
          .where((car) => car.id != carId)
          .toList();

      emit(
        state.copyWith(
          userCars: updatedCarsList,
          isLoading: false,
        ),
      );

      await deleteCarUseCase.execute(
        carId,
      );
    } catch (e) {
      print('Error deleting car: $e');
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    }
  }

  Future<void> fetchUserCarsData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final cars = await getUserCarsUseCase.execute();
      if (cars != null) {
        print('User cars fetched successfully: $cars');
        emit(
          state.copyWith(
            userCars: cars,
            isLoading: false,
            isUserAuthenticated: true,
          ),
        );
      } else {
        print('User cars is null');
        emit(
          state.copyWith(
            isLoading: false,
            isUserAuthenticated: false,
            clearUserData: true,
          ),
        );
      }
    } catch (e) {
      print('Error fetching user cars: $e');
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
          clearUserData: true,
        ),
      );
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
}
