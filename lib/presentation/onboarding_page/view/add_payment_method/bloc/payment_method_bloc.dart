import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_state.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final AddPaymentMethodUseCase addPaymentMethodUseCase =
      AddPaymentMethodUseCase();
  final FetchPaymentMethodsUseCase fetchPaymentMethodsUseCase =
      FetchPaymentMethodsUseCase();
  final UpdateDefaultCreditCardUseCase updateDefaultCreditCardUseCase =
      UpdateDefaultCreditCardUseCase();
  final UpdateDefaultReceivingEarningsUseCase
  updateDefaultReceivingEarningsUseCase =
      UpdateDefaultReceivingEarningsUseCase();

  PaymentMethodBloc() : super(PaymentMethodState()) {
    on<CardNameVerificationEvent>((event, emit) {
      final validationError = StringHelperMethods.validateMinLength(
        value: event.value,
        minLength: 4,
        errorMessage: 'Name should be at least 4 symbols',
      );

      emit(
        state.copyWith(
          cardNameError: () => validationError,
        ),
      );
    });

    on<CardNumberVerificationEvent>((event, emit) {
      final validationError = StringHelperMethods.validateMinLength(
        value: event.value,
        minLength: 16,
        errorMessage: 'Card number should be at least 16 digits',
      );

      emit(
        state.copyWith(
          cardNumberError: () => validationError,
        ),
      );
    });

    on<ExpiryVerificationEvent>((event, emit) {
      final validationError = StringHelperMethods.validateMinLength(
        value: event.value,
        minLength: 4,
        errorMessage: 'The date is invalid',
      );

      emit(
        state.copyWith(
          expiryError: () => validationError,
        ),
      );
    });

    on<CvvVerificationEvent>((event, emit) {
      final validationError = StringHelperMethods.validateMinLength(
        value: event.value,
        minLength: 3,
        errorMessage: 'CVV must be 3 digits',
      );

      emit(
        state.copyWith(
          cvvError: () => validationError,
        ),
      );
    });

    on<FilledCreditCardEvent>((event, emit) async {
      try {
        await addPaymentMethodUseCase.execute(event.card);
        emit(
          state.copyWith(
            creditCard: event.card,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<IbanVerificationEvent>((event, emit) {
      String? ibanError;

      if (event.value.isNotEmpty && event.value.length < 15) {
        ibanError = 'This IBAN is too short. Please check the number.';
      }

      emit(
        state.copyWith(
          ibanError: () => ibanError,
        ),
      );
    });

    on<FilledIbanEvent>((event, emit) async {
      try {
        // await addPaymentMethodUseCase.execute(event.iban);
        emit(
          state.copyWith(
            iban: event.iban,
            ibanError: () => null,
          ),
        );
      } catch (e) {
        print('Error: $e');
      }
    });

    on<RemovePaymentMethodEvent>((event, emit) {
      final List<CreditCardModel> updatedList = state.paymentMethods!
          .where((method) => method.id != event.paymentMethodId)
          .toList();

      emit(
        state.copyWith(
          paymentMethods: updatedList,
        ),
      );
    });

    on<FetchPaymentMethodsEvent>((event, emit) async {
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

    on<UpdateDefaultCreditCardEvent>((event, emit) async {
      try {
        await updateDefaultCreditCardUseCase.execute(
          event.creditCardId,
          event.isDefault,
        );

        final List<CreditCardModel> updatedPaymentMethodsList =
            (state.paymentMethods ?? []).map((paymentMethod) {
              return paymentMethod.id == event.creditCardId
                  ? paymentMethod.copyCreditCardWith(
                      isDefaultPaymentMethod: event.isDefault,
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
    });

    // on<UpdateDefaultReceivingEarningsEvent>((event, emit) async {
    //   try {
    //     await updateDefaultReceivingEarningsUseCase.execute(
    //       event.ibanId,
    //       event.isReceiver,
    //     );
    //
    //     final List<IbanModel> updatedPaymentMethodsList =
    //         (state.paymentMethods ?? []).map((paymentMethod) {
    //           return paymentMethod.id == event.ibanId
    //               ? paymentMethod.copyIbanWith(
    //                   isUsedForReceivingEarnings: event.isReceiver,
    //                 )
    //               : paymentMethod;
    //         }).toList();
    //
    //     emit(
    //       state.copyWith(
    //         paymentMethods: updatedPaymentMethodsList,
    //       ),
    //     );
    //   } catch (e) {
    //     print('Error: $e');
    //   }
    // });
  }
}
