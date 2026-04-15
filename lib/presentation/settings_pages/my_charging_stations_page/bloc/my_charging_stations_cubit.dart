import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';

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
  final AddCarUseCase updateUserCarUseCase = AddCarUseCase();
  final FetchUserCarsUseCase fetchUserCarsUseCase = FetchUserCarsUseCase();
  final DeleteCarUseCase deleteCarUseCase = DeleteCarUseCase();
  final FetchUserCarsUseCase getUserCarsUseCase = FetchUserCarsUseCase();
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

  Future<void> saveChargingStationName(
    String stationName,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      emit(
        state.copyWith(
          chargingStation: state.chargingStation?.copyChargingStationWith(
            chargingStationName: stationName,
          ),
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

  Future<void> saveChargingStationBrand(
    String brandName,
    String brandLogo,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      emit(
        state.copyWith(
          chargingStation: state.chargingStation?.copyChargingStationWith(
            brandName: brandName,
            brandLogo: brandLogo,
          ),
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

  // Future<void> saveNewCar(ChargingStationModel chargingStation) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     await updateUserCarUseCase.execute(chargingStation);
  //
  //     final List<ChargingStationModel> updateCarsList = [...?state.userCars, chargingStation];
  //
  //     emit(
  //       state.copyWith(
  //         userCars: updateCarsList,
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error adding car: $e');
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> deleteCar(String carId) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final updatedCarsList = (state.userCars ?? [])
  //         .where((car) => car.id != carId)
  //         .toList();
  //
  //     emit(
  //       state.copyWith(
  //         userCars: updatedCarsList,
  //         isLoading: false,
  //       ),
  //     );
  //
  //     await deleteCarUseCase.execute(
  //       carId,
  //     );
  //   } catch (e) {
  //     print('Error deleting car: $e');
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }

  // Future<void> fetchMockedCarModelsData() async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final Map<MockedCarBrand, List<String>> carModelOptions =
  //     await fetchMockedCarModelOptionsUseCase.execute();
  //
  //     emit(
  //       state.copyWith(
  //         carModelOptions: carModelOptions,
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.toString(),
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> saveNewCar(CarModel car) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     await updateUserCarUseCase.execute(car);
  //
  //     final List<CarModel> updateCarsList = [...?state.userCars, car];
  //
  //     emit(
  //       state.copyWith(
  //         userCars: updateCarsList,
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error adding car: $e');
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> deleteCar(String carId) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final updatedCarsList = (state.userCars ?? [])
  //         .where((car) => car.id != carId)
  //         .toList();
  //
  //     emit(
  //       state.copyWith(
  //         userCars: updatedCarsList,
  //         isLoading: false,
  //       ),
  //     );
  //
  //     await deleteCarUseCase.execute(
  //       carId,
  //     );
  //   } catch (e) {
  //     print('Error deleting car: $e');
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> fetchUserCarsData() async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final cars = await getUserCarsUseCase.execute();
  //     if (cars != null) {
  //       print('User cars fetched successfully: $cars');
  //       emit(
  //         state.copyWith(
  //           userCars: cars,
  //           isLoading: false,
  //           isUserAuthenticated: true,
  //         ),
  //       );
  //     } else {
  //       print('User cars is null');
  //       emit(
  //         state.copyWith(
  //           isLoading: false,
  //           isUserAuthenticated: false,
  //           clearUserData: true,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error fetching user cars: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.toString(),
  //         isLoading: false,
  //         clearUserData: true,
  //       ),
  //     );
  //   }
  // }

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
