import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/menu_pages/my_payment_methods_page/bloc/my_payment_methods_state.dart';
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
