import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/user_model.dart';

class MyCarsState {
  final bool isUserAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final List<CarModel>? userCars;
  final UserModel? userData;
  final List<MockedCarOption>? carOptions;
  final Map<MockedCarBrand, List<String>>? carModelOptions;
  final String? plateNumberError;
  final String? modelError;

  MyCarsState({
    required this.isUserAuthenticated,
    this.isLoading = false,
    this.errorMessage,
    this.userCars,
    this.userData,
    this.carOptions,
    this.carModelOptions,
    this.plateNumberError,
    this.modelError,
  });

  MyCarsState copyWith({
    bool? isUserAuthenticated,
    bool? isLoading,
    String? errorMessage,
    List<CarModel>? userCars,
    UserModel? userData,
    bool clearUserData = false,
    List<MockedCarOption>? carOptions,
    Map<MockedCarBrand, List<String>>? carModelOptions,
    String? Function()? plateNumberError,
    String? Function()? modelError,
  }) {
    return MyCarsState(
      isUserAuthenticated: isUserAuthenticated ?? this.isUserAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      userCars: userCars ?? this.userCars,
      userData: clearUserData ? null : (userData ?? this.userData),
      carOptions: carOptions ?? this.carOptions,
      carModelOptions: carModelOptions ?? this.carModelOptions,
      plateNumberError: plateNumberError != null
          ? plateNumberError()
          : this.plateNumberError,
      modelError: modelError != null ? modelError() : this.modelError,
    );
  }
}
