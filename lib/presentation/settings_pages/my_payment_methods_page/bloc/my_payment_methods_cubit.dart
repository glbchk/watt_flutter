import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/settings_pages/my_payment_methods_page/bloc/my_payment_methods_state.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class MyPaymentMethodsCubit extends Cubit<MyPaymentMethodsState> {
  final AuthBloc authBloc;
  late StreamSubscription authSubscription;

  final AddPaymentMethodUseCase addPaymentMethodUseCase =
      AddPaymentMethodUseCase();
  final FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();
  final UpdateDefaultCreditCardUseCase updateDefaultCreditCardUseCase =
      UpdateDefaultCreditCardUseCase();
  final RemovePaymentMethodUseCase removePaymentMethodUseCase =
      RemovePaymentMethodUseCase();
  final GetUserDataUseCase getUserDataUseCase = GetUserDataUseCase();

  MyPaymentMethodsCubit({required this.authBloc})
    : super(
        MyPaymentMethodsState(isUserAuthenticated: true, isLoading: true),
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

  void verifyCardName(String cardName) {
    final validationError = StringHelperMethods.validateMinLength(
      value: cardName,
      minLength: 4,
      errorMessage: 'Name should be at least 4 symbols',
    );

    emit(
      state.copyWith(
        cardNameError: () => validationError,
      ),
    );
  }

  void verifyCardNumber(String cardNumber) {
    final validationError = StringHelperMethods.validateMinLength(
      value: cardNumber,
      minLength: 16,
      errorMessage: 'Card number should be at least 16 digits',
    );

    emit(
      state.copyWith(
        cardNumberError: () => validationError,
      ),
    );
  }

  void verifyExpiryDate(String expiryDate) {
    final validationError = StringHelperMethods.validateMinLength(
      value: expiryDate,
      minLength: 4,
      errorMessage: 'The date is invalid',
    );

    emit(
      state.copyWith(
        expiryError: () => validationError,
      ),
    );
  }

  void verifyCvv(String cvv) {
    final validationError = StringHelperMethods.validateMinLength(
      value: cvv,
      minLength: 3,
      errorMessage: 'CVV must be 3 digits',
    );

    emit(
      state.copyWith(
        cvvError: () => validationError,
      ),
    );
  }

  Future<void> saveCreditCard(CreditCardModel creditCard) async {
    try {
      await addPaymentMethodUseCase.execute(creditCard);

      final List<CreditCardModel> updatedPaymentMethodsList = [
        ...?state.paymentMethods,
        creditCard,
      ];

      emit(
        state.copyWith(
          creditCard: () => creditCard,
          paymentMethods: updatedPaymentMethodsList,
          cardNameError: () => null,
          cardNumberError: () => null,
          expiryError: () => null,
          cvvError: () => null,
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateDefaultCreditCard(
    String creditCardId,
    bool isDefault,
  ) async {
    try {
      await updateDefaultCreditCardUseCase.execute(creditCardId, isDefault);

      final List<CreditCardModel> updatedPaymentMethodsList =
          (state.paymentMethods ?? []).map((paymentMethod) {
            return paymentMethod.id == creditCardId
                ? paymentMethod.copyCreditCardWith(
                    isDefaultPaymentMethod: isDefault,
                  )
                : paymentMethod;
          }).toList();

      emit(
        state.copyWith(
          paymentMethods: updatedPaymentMethodsList,
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> removeCreditCard(String creditCardId) async {
    await removePaymentMethodUseCase.execute(creditCardId);

    final List<CreditCardModel> updatedList = state.paymentMethods!
        .where((method) => method.id != creditCardId)
        .toList();

    emit(
      state.copyWith(
        paymentMethods: updatedList,
      ),
    );
  }

  void clearCreditCardDetails() {
    emit(
      state.copyWith(
        creditCard: () => null,
        cardNameError: () => null,
        cardNumberError: () => null,
        expiryError: () => null,
        cvvError: () => null,
      ),
    );
  }

  Future<void> fetchPaymentMethods() async {
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
  }

  // on<UpdateDefaultReceivingEarningsEvent>((event, emit) async {
  // try {
  // await updateDefaultReceivingEarningsUseCase.execute(
  // event.ibanId,
  // event.isReceiver,
  // );
  //
  // final List<PaymentMethodModel> updatedPaymentMethodsList =
  // (state.paymentMethods ?? []).map((paymentMethod) {
  // if (paymentMethod is IbanModel) {
  // return paymentMethod.id == event.ibanId
  // ? paymentMethod.copyIbanWith(
  // isUsedForReceivingEarnings: event.isReceiver,
  // )
  //     : paymentMethod;
  // }
  //
  // return paymentMethod;
  // }).toList();
  //
  // emit(
  // state.copyWith(
  // paymentMethods: updatedPaymentMethodsList,
  // ),
  // );
  // } catch (e) {
  // print('Error: $e');
  // }
  // });
  //
  // void initializeChargingStation() {
  //   emit(
  //     state.copyWith(
  //       chargingStation: ChargingStationModel(id: Uuid().v4()),
  //     ),
  //   );
  // }
  //
  // void saveChargingStationName(
  //   String stationName,
  // ) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         chargingStationName: stationName,
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<void> fetchLocationSuggestions(String location) async {
  //   try {
  //     final List<String> suggestions = await fetchLocationSuggestionsUseCase
  //         .execute(location);
  //
  //     emit(
  //       state.copyWith(
  //         locationSuggestions: suggestions,
  //       ),
  //     );
  //   } catch (e) {
  //     print("Error fetching suggestion locations: $e");
  //   }
  // }
  //
  // Future<void> goToMyLocation() async {
  //   try {
  //     final Position? position = await goToMyLocationUseCase.execute();
  //
  //     if (position != null) {
  //       final String address =
  //           await GoogleMapsHelperMethods.convertPositionToAddress(position);
  //       print("Position: $position");
  //       print("Position: $address");
  //       emit(
  //         state.copyWith(
  //           chargingStation: state.chargingStation?.copyChargingStationWith(
  //             address: address,
  //             addressLatitude: position.latitude,
  //             addressLongitude: position.longitude,
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
  //
  // Future<void> searchMyLocation(
  //   String address,
  //   GoogleMapController? mapController,
  // ) async {
  //   try {
  //     final LocationResult? locationResult = await searchLocationUseCase
  //         .execute(
  //           address,
  //           mapController,
  //         );
  //
  //     print("Position: ${locationResult?.position}");
  //     emit(
  //       state.copyWith(
  //         chargingStation: state.chargingStation?.copyChargingStationWith(
  //           address: locationResult?.address,
  //           addressLatitude: locationResult?.position.latitude,
  //           addressLongitude: locationResult?.position.longitude,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Not possible to find address: $e");
  //   }
  // }
  //
  // Future<void> handleMapTap(LatLng tappedPoint) async {
  //   try {
  //     print('mapController result: ${tappedPoint}');
  //
  //     final String? tapResult = await handleMapTapUseCase.execute(
  //       tappedPoint,
  //     );
  //
  //     final Position? addressPosition =
  //         await GoogleMapsHelperMethods.convertAddressToPosition(
  //           tapResult ?? '',
  //         );
  //     emit(
  //       state.copyWith(
  //         chargingStation: state.chargingStation?.copyChargingStationWith(
  //           address: tapResult,
  //           addressLatitude: addressPosition?.latitude,
  //           addressLongitude: addressPosition?.longitude,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Not possible to find address: $e");
  //   }
  // }
  //
  // Future<void> chooseLocationOnMap() async {
  //   try {
  //     final LocationResult? locationResult = await chooseLocationOnMapUseCase
  //         .execute();
  //
  //     emit(
  //       state.copyWith(
  //         chargingStation: state.chargingStation?.copyChargingStationWith(
  //           address: locationResult?.address,
  //           addressLatitude: locationResult?.position.latitude,
  //           addressLongitude: locationResult?.position.longitude,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print("Not possible to find address: $e");
  //   }
  // }
  //
  // void saveAddress(
  //   String address,
  //   double? addressLatitude,
  //   double? addressLongitude,
  // ) async {
  //   final position = await GoogleMapsHelperMethods.convertAddressToPosition(
  //     address,
  //   );
  //   emit(
  //     state.copyWith(
  //       locationSuggestions: [],
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         address: address,
  //         addressLatitude: addressLatitude ?? position?.latitude,
  //         addressLongitude: addressLongitude ?? position?.longitude,
  //       ),
  //     ),
  //   );
  // }
  //
  // void clearAddress() {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         address: '',
  //         addressLatitude: null,
  //         addressLongitude: null,
  //       ),
  //       locationSuggestions: [],
  //     ),
  //   );
  // }
  //
  // void saveChargingStationBrand(
  //   String brandName,
  //   String brandLogo,
  // ) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         brandName: brandName,
  //         brandLogo: brandLogo,
  //       ),
  //     ),
  //   );
  // }
  //
  // void saveChargingEffect(String chargingEffect) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         chargingEffect: chargingEffect,
  //       ),
  //     ),
  //   );
  // }
  //
  // void savePlug(String plug) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         plug: plug,
  //       ),
  //     ),
  //   );
  // }
  //
  // void savePrice(String price) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         pricePerKwh: price,
  //       ),
  //     ),
  //   );
  // }
  //
  // void verifyIban(String value) {
  //   String? ibanError;
  //
  //   if (value.isEmpty) {
  //     ibanError = 'Please enter an IBAN number.';
  //   } else if (value.length < 15) {
  //     ibanError = 'This IBAN is too short. Please check the number.';
  //   } else if (value.length > 34) {
  //     ibanError = 'This IBAN is too long. Please check the number.';
  //   }
  //
  //   emit(
  //     state.copyWith(
  //       ibanError: () => ibanError,
  //     ),
  //   );
  // }
  //
  // void saveIban(IbanModel iban) {
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         bankAccount: iban,
  //       ),
  //     ),
  //   );
  // }
  //
  // void removeIban() {
  //   final IbanModel clearIban = IbanModel(
  //     id: '',
  //     isUsedForReceivingEarnings: false,
  //   );
  //
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         bankAccount: clearIban,
  //       ),
  //     ),
  //   );
  // }
  //
  // void verifyAvailableHours(
  //   List<int> availableDays,
  //   String startTime,
  //   String endTime,
  // ) {
  //   String? daysError;
  //   String? startError;
  //   String? endError;
  //
  //   if (availableDays.isEmpty) {
  //     daysError = 'At least one day should be added.';
  //   }
  //
  //   if (startTime.isEmpty) {
  //     startError = 'Start time should be selected.';
  //   }
  //
  //   if (endTime.isEmpty) {
  //     endError = 'End time should be selected.';
  //   }
  //
  //   emit(
  //     state.copyWith(
  //       availableDaysError: () => daysError,
  //       startTimeError: () => startError,
  //       endTimeError: () => endError,
  //     ),
  //   );
  // }
  //
  // void addTimeSlot(TimeSlotModel timeSlot) {
  //   final List<TimeSlotModel> updatedTimeSlots = [
  //     ...?state.chargingStation?.availableHours,
  //     timeSlot,
  //   ];
  //
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         availableHours: updatedTimeSlots,
  //       ),
  //     ),
  //   );
  // }
  //
  // void removeTimeSlot(String timeSlotId) {
  //   final List<TimeSlotModel>? updatedList = state
  //       .chargingStation
  //       ?.availableHours!
  //       .where((slot) => slot.id != timeSlotId)
  //       .toList();
  //
  //   emit(
  //     state.copyWith(
  //       chargingStation: state.chargingStation?.copyChargingStationWith(
  //         availableHours: updatedList,
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<void> saveNewChargingStation(
  //   ChargingStationModel chargingStation,
  // ) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final List<ChargingStationModel> chargingStationsUpdated = [
  //       ...?state.userChargingStations,
  //       chargingStation,
  //     ];
  //     await addChargingStationsUseCase.execute(chargingStationsUpdated);
  //
  //     emit(
  //       state.copyWith(
  //         chargingStations: chargingStationsUpdated,
  //         isLoading: false,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error adding charging station: $e');
  //     emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  //   }
  // }
  //
  // Future<void> fetchChargingStations() async {
  //   emit(state.copyWith(isLoading: true));
  //
  //   try {
  //     final List<ChargingStationModel> chargingStations =
  //         await fetchUserChargingStationsUseCase.execute();
  //
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         userChargingStations: chargingStations,
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error fetching charging stations: $e');
  //     emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
  //   }
  // }
  //
  // Future<void> deleteChargingStation(String stationId) async {
  //   emit(state.copyWith(isLoading: true));
  //   try {
  //     final updatedChargingStationsList = (state.userChargingStations ?? [])
  //         .where((station) => station.id != stationId)
  //         .toList();
  //
  //     emit(
  //       state.copyWith(
  //         userChargingStations: updatedChargingStationsList,
  //         isLoading: false,
  //       ),
  //     );
  //
  //     await deleteChargingStationUseCase.execute(stationId);
  //   } catch (e) {
  //     print('Error removing charging station: $e');
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.toString(),
  //         isLoading: false,
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
