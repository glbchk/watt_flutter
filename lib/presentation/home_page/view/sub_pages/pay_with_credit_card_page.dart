import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/home_page/view/components/credit_card_widget.dart';
import 'package:watt/presentation/menu_pages/my_payment_methods_page/my_payment_methods_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class PayWithCreditCardPage extends StatefulWidget {
  final BookingModel booking;
  const PayWithCreditCardPage({super.key, required this.booking});

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.paymentMethods != null && state.paymentMethods!.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MyPaymentMethodsPage()),
          );
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final paymentMethods = state.paymentMethods ?? [];
        print('Payment methods in state: ${paymentMethods.length}');

        if (paymentMethods.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final safeIndex = _currentIndex.clamp(0, paymentMethods.length - 1);
        final currentCard = paymentMethods[safeIndex];
        final cardType = StringHelperMethods.getCardType(
          currentCard.cardNumber ?? '',
        );

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
                    });
                  },
                  itemBuilder: (context, index) {
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
                      context.read<HomeCubit>().confirmBookingWithPayment(
                        widget.booking,
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
