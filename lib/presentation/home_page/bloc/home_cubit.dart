import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/domain/use_cases/get_mock_data_usecase.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FetchMockedChargingStationsUseCase fetchMockedChargingStationsUseCase =
      FetchMockedChargingStationsUseCase();
  final LogoutUserUseCase logoutUserUseCase = LogoutUserUseCase();

  HomeCubit() : super(HomeState(isUserAuthenticated: false));

  Future<void> fetchMockedChargingStations() async {
    try {
      final chargingStations = await fetchMockedChargingStationsUseCase
          .execute();
      emit(state.copyWith(chargingStationsOnMap: chargingStations));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUserUseCase.execute();
    } catch (e) {
      print(e.toString());
      // emit(AuthErrorState(e.toString()));
    }
  }
}
