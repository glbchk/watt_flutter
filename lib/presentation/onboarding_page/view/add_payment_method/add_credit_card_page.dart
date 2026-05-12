import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/components/credit_card_form_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

enum CardNetwork {
  visa,
  mastercard,
  amex,
  discover,
  unknown,
}

class AddCreditCardPage extends StatefulWidget {
  const AddCreditCardPage({super.key});

  @override
  State<AddCreditCardPage> createState() => _AddCreditCardPageState();
}

class _AddCreditCardPageState extends State<AddCreditCardPage> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool isDefaultPaymentMethod = false;

  @override
  void dispose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: cardNumberController,
          builder: (context, value, child) {
            String cardType = StringHelperMethods.getCardType(
              cardNumberController.text,
            );
            String assetPath = StringHelperMethods.getNetworkLogoAssetPath(
              cardType,
            );

            return DefaultAppBar(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: false,
              title: 'Credit card details',
              titleColor: context.theme.appColors.onPrimary,
              scaffoldBackgroundColor: context.theme.appColors.primary,
              leading: BackButton(
                onPressed: () {
                  context.read<PaymentMethodBloc>().add(
                    CardNameVerificationEvent(value: ''),
                  );
                  context.read<PaymentMethodBloc>().add(
                    CardNumberVerificationEvent(value: ''),
                  );
                  context.read<PaymentMethodBloc>().add(
                    ExpiryVerificationEvent(value: ''),
                  );
                  context.read<PaymentMethodBloc>().add(
                    CvvVerificationEvent(value: ''),
                  );
                  Navigator.of(context).pop();
                },
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: context.theme.appColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CreditCardFormWidget(
                    controllerCardName: cardNameController,
                    errorCardName: state.cardNameError,
                    onChangedCardName: (String? value) {
                      print(value);
                      context.read<PaymentMethodBloc>().add(
                        CardNameVerificationEvent(
                          value: value ?? '',
                        ),
                      );
                    },
                    controllerCardNumber: cardNumberController,
                    errorCardNumber: state.cardNumberError,
                    cardNumberPrefixIcon: assetPath.isNotEmpty
                        ? SvgPicture.asset(assetPath)
                        : SvgPicture.asset(KPaymentProvidersIcons.generic),
                    onChangedCardNumber: (String? value) {
                      print(value);
                      context.read<PaymentMethodBloc>().add(
                        CardNumberVerificationEvent(
                          value: value ?? '',
                        ),
                      );
                    },
                    controllerExpiry: expiryController,
                    errorExpiry: state.expiryError,
                    onChangedExpiry: (String? value) {
                      print(value);
                      context.read<PaymentMethodBloc>().add(
                        ExpiryVerificationEvent(
                          value: value ?? '',
                        ),
                      );
                    },
                    controllerCvv: cvvController,
                    errorCvv: state.cvvError,
                    onChangedCvv: (String? value) {
                      print(value);
                      context.read<PaymentMethodBloc>().add(
                        CvvVerificationEvent(
                          value: value ?? '',
                        ),
                      );
                    },
                    isSwitched: isDefaultPaymentMethod,
                    onChanged: (bool newValue) {
                      setState(() {
                        isDefaultPaymentMethod = newValue;
                      });
                    },
                    onPressSave: () {
                      final paymentMethods = state.paymentMethods ?? [];

                      final existingCreditCards = paymentMethods
                          .whereType<CreditCardModel>();

                      final bool shouldBeDefault =
                          existingCreditCards.isEmpty || isDefaultPaymentMethod;

                      if (shouldBeDefault) {
                        for (final card in existingCreditCards) {
                          if (card.isDefaultPaymentMethod == true) {
                            context.read<PaymentMethodBloc>().add(
                              UpdateDefaultCreditCardEvent(
                                creditCardId: card.id,
                                isDefault: false,
                              ),
                            );
                          }
                        }
                      }

                      final paymentMethod = CreditCardModel(
                        id: Uuid().v4(),
                        cardName: cardNameController.text,
                        networkLogo: assetPath,
                        cardNumber: cardNumberController.text,
                        expiry: expiryController.text,
                        cvv: cvvController.text,
                        isDefaultPaymentMethod: shouldBeDefault,
                      );

                      context.read<PaymentMethodBloc>().add(
                        FilledCreditCardEvent(card: paymentMethod),
                      );

                      Navigator.pop(context, paymentMethod);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
