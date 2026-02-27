import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_state.dart';

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

  String? _validateMinLength({
    required String value,
    required int minLength,
    required String errorMessage,
  }) {
    if (value.isEmpty) return null;
    if (value.length < minLength) return errorMessage;
    return null;
  }

  PaymentMethodBloc() : super(PaymentMethodState()) {
    on<CardNameVerificationEvent>((event, emit) {
      emit(
        state.copyWith(
          cardNameError: () => _validateMinLength(
            value: event.value,
            minLength: 4,
            errorMessage: 'Name should be at least 4 symbols',
          ),
        ),
      );
    });

    on<CardNumberVerificationEvent>((event, emit) {
      emit(
        state.copyWith(
          cardNumberError: () => _validateMinLength(
            value: event.value,
            minLength: 16,
            errorMessage: 'Card number should be at least 16 digits',
          ),
        ),
      );
    });

    on<ExpiryVerificationEvent>((event, emit) {
      emit(
        state.copyWith(
          expiryError: () => _validateMinLength(
            value: event.value,
            minLength: 4,
            errorMessage: 'The date is invalid',
          ),
        ),
      );
    });

    on<CvvVerificationEvent>((event, emit) {
      emit(
        state.copyWith(
          cvvError: () => _validateMinLength(
            value: event.value,
            minLength: 3,
            errorMessage: 'CVV must be 3 digits',
          ),
        ),
      );
    });

    on<FilledCreditCardEvent>((event, emit) async {
      emit(
        state.copyWith(
          creditCard: () => event.card,
        ),
      );
      await addPaymentMethodUseCase.execute(event.card);
    });

    on<FilledIbanEvent>((event, emit) async {
      emit(
        state.copyWith(
          iban: () => event.iban,
        ),
      );
      await addPaymentMethodUseCase.execute(event.iban);
    });

    on<FetchPaymentMethodsEvent>((event, emit) async {
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

    on<UpdateDefaultCreditCardEvent>((event, emit) async {
      await updateDefaultCreditCardUseCase.execute(
        event.creditCardId,
        event.isDefault,
      );

      final List<PaymentMethodModel> updatedPaymentMethodsList =
          (state.paymentMethods ?? []).map((paymentMethod) {
            if (paymentMethod is CreditCardModel) {
              return paymentMethod.id == event.creditCardId
                  ? paymentMethod.copyCreditCardWith(
                      isDefaultPaymentMethod: event.isDefault,
                    )
                  : paymentMethod;
            }

            return paymentMethod;
          }).toList();

      emit(
        state.copyWith(
          paymentMethods: () => updatedPaymentMethodsList,
        ),
      );
    });

    on<UpdateDefaultReceivingEarningsEvent>((event, emit) async {
      await updateDefaultReceivingEarningsUseCase.execute(
        event.ibanId,
        event.isReceiver,
      );

      final List<PaymentMethodModel> updatedPaymentMethodsList =
          (state.paymentMethods ?? []).map((paymentMethod) {
            if (paymentMethod is IbanModel) {
              return paymentMethod.id == event.ibanId
                  ? paymentMethod.copyIbanWith(
                      isUsedForReceivingEarnings: event.isReceiver,
                    )
                  : paymentMethod;
            }

            return paymentMethod;
          }).toList();

      emit(
        state.copyWith(
          paymentMethods: () => updatedPaymentMethodsList,
        ),
      );
    });
  }
}
