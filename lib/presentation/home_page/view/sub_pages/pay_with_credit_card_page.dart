import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/home_page/view/components/credit_card_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class PayWithCreditCardPage extends StatefulWidget {
  final String bookingId;
  const PayWithCreditCardPage({super.key, required this.bookingId});

  @override
  State<PayWithCreditCardPage> createState() => _PayWithCreditCardPageState();
}

class _PayWithCreditCardPageState extends State<PayWithCreditCardPage> {
  PageController controller = PageController(viewportFraction: 1.0);

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchPaymentMethods();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  // void _updateTextFields(CreditCardModel card) {
  //   cardNumberController.text = card.cardNumber ?? '';
  //   cardHolderController.text = card.cardName ?? '';
  //   expiryDateController.text = card.expiry ?? '';
  //   cvvController.text = '***';
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // final paymentMethods = [
        //   CreditCardModel(
        //     id: '1',
        //     cardName: 'First Card',
        //     cardNumber: '3341 5678 9012 3456',
        //     expiry: '1/11',
        //     cvv: '345',
        //     networkLogo: '',
        //     isDefaultPaymentMethod: true,
        //   ),
        //   CreditCardModel(
        //     id: '2',
        //     cardName: 'Second Card',
        //     cardNumber: '3530 2345 6789 1012',
        //     expiry: '2/24',
        //     cvv: '456',
        //     networkLogo: '',
        //     isDefaultPaymentMethod: true,
        //   ),
        //   CreditCardModel(
        //     id: '3',
        //     cardName: 'Third Card',
        //     cardNumber: '3144 5678 9012 3456',
        //     expiry: '3/23',
        //     cvv: '123',
        //     networkLogo: KPaymentProvidersIcons.visa,
        //     isDefaultPaymentMethod: true,
        //   ),
        // ];
        final paymentMethods = state.paymentMethods ?? [];
        print('Payment methods in state: ${paymentMethods.length}');

        // if (state.isLoading) {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }

        if (paymentMethods.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No payment methods found')),
          );
        }

        final currentCard = paymentMethods[_currentIndex];
        //
        // cardNumberController.text = currentCard.cardNumber ?? '';
        // cardHolderController.text = currentCard.cardName ?? '';
        // expiryDateController.text = currentCard.expiry ?? '';
        //
        final cardType = StringHelperMethods.getCardType(
          currentCard.cardNumber ?? '',
        );

        // final rawCard = currentCard.cardNumber ?? "";
        // final lastFour = rawCard.length >= 4
        //     ? rawCard.substring(rawCard.length - 4)
        //     : rawCard;
        // final fourDigitsFormatted = lastFour.split('').join(' ');

        // if (paymentMethods.isNotEmpty && cardNumberController.text.isEmpty) {
        //   _updateTextFields(paymentMethods[0]);
        // }

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          title: 'Select Payment Method',
          titleColor: context.theme.appColors.onSecondary,
          appBarBackgroundColor: context.theme.appColors.background,
          scaffoldBackgroundColor: context.theme.appColors.background,
          blurRadius: 30,
          leading: BackButton(
            color: context.theme.appColors.onSecondary,
            onPressed: () {
              // context.read<OnboardingBloc>().add(
              //   NameVerificationEvent(value: ''),
              // );
              // context.read<OnboardingBloc>().add(
              //   PhoneNumberVerificationEvent(value: ''),
              // );
              Navigator.of(context).pop();
            },
          ),
          body: SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: paymentMethods.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      // _updateTextFields(paymentMethods[index]);
                    });
                  },
                  itemBuilder: (context, index) {
                    // final card = paymentMethods[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          CreditCardWidget(
                            bg: StringHelperMethods.getCreditCardBGAssetPath(
                              cardType,
                            ),
                            networkLogo:
                                StringHelperMethods.getNetworkLogoAssetPath(
                                  cardType,
                                ),
                            cardNumber: currentCard.cardNumber ?? '',
                            cardHolder: currentCard.cardName ?? '',
                            expiry: currentCard.expiry ?? '',
                            cvv: currentCard.cvv ?? '',
                          ),

                          const SizedBox(height: 60),

                          Column(
                            spacing: 20,
                            children: [
                              CustomTextField(
                                label: 'Card number',
                                initialValue: currentCard.cardNumber ?? '',
                                readOnly: true,
                              ),
                              CustomTextField(
                                label: 'Card holder',
                                initialValue: currentCard.cardName ?? '',
                                readOnly: true,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Expiry date',
                                      initialValue: currentCard.expiry ?? '',
                                      readOnly: true,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'CVV',
                                      initialValue: '***',
                                      readOnly: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Positioned(
                  top: 245,
                  left: 0,
                  right: 0,
                  child: _buildDots(paymentMethods.length),
                ),

                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: WattMainButton(
                    label: 'Select Method',
                    onPressed: () {
                      final cardNumber = currentCard.cardNumber ?? '';
                      context.read<HomeCubit>().setSlotIsBusy(
                        widget.bookingId,
                        state.selectedSlots ?? [],
                        cardNumber,
                      );
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
