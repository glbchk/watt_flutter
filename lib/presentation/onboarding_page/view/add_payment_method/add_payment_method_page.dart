import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/add_credit_card_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/add_iban_details_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/bloc/payment_method_state.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final double marginSize = 15.0;

  @override
  void initState() {
    context.read<PaymentMethodBloc>().add(
      FetchPaymentMethodsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: wattGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add payment method',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Select your payment method',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 60.0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: context.theme.appColors.background,
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.paymentMethods != null &&
                                    state.paymentMethods!.isNotEmpty) ...[
                                  ...state.paymentMethods!.map((paymentMethod) {
                                    return TallCardButton(
                                      isDismissible: true,
                                      dismissableKey: paymentMethod.id,
                                      onDismissableDismissed: () {
                                        context.read<PaymentMethodBloc>().add(
                                          RemovePaymentMethodEvent(
                                            paymentMethod.id,
                                          ),
                                        );
                                      },
                                      label: paymentMethod.cardName ?? '',
                                      subLabel:
                                          '${paymentMethod.cardNumber}${paymentMethod.isDefaultPaymentMethod == true ? ' * Default' : ''}',
                                      svgImage:
                                          (paymentMethod.networkLogo != null &&
                                              paymentMethod
                                                  .networkLogo!
                                                  .isNotEmpty)
                                          ? paymentMethod.networkLogo
                                          : null,
                                      marginDistance: marginSize,
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) =>
                                        //         AddCreditCardPage(),
                                        //   ),
                                        // );
                                      },
                                    );
                                    // } else if (paymentMethod is IbanModel) {
                                    // return TallCardButton(
                                    //   isDismissible: true,
                                    //   label: 'IBAN Method',
                                    //   subLabel:
                                    //       '${paymentMethod.ibanNumber?.substring(0, 16)}${paymentMethod.isUsedForReceivingEarnings == true ? ' * Receiver' : ''}',
                                    //   svgImage: KCardIcons.paymentMethod,
                                    //   marginDistance: marginSize,
                                    //   onPressed: () {
                                    //     // Navigator.push(
                                    //     //   context,
                                    //     //   MaterialPageRoute(
                                    //     //     builder: (_) =>
                                    //     //         AddIbanDetailsPage(),
                                    //     //   ),
                                    //     // );
                                    //   },
                                    // );
                                    // } else {
                                    //   return SizedBox(
                                    //     height: 1,
                                    //   );
                                    // }
                                  }),
                                  const SizedBox(height: 30.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text(
                                      'Add Another Car'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.theme.appColors.grey1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                                TallCardButton(
                                  isDismissible: false,
                                  label: 'Credit Card',
                                  svgImage: KCardIcons.paymentMethod,
                                  iconColor: context.theme.appColors.primary,
                                  marginDistance: marginSize,
                                  onPressed: () async {
                                    final result =
                                        await Navigator.push<CreditCardModel>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddCreditCardPage(),
                                          ),
                                        );

                                    if (!context.mounted) return;

                                    if (result != null) {
                                      context.read<PaymentMethodBloc>().add(
                                        FetchPaymentMethodsEvent(),
                                      );
                                    }
                                  },
                                ),
                                TallCardButton(
                                  isDismissible: false,
                                  label: 'IBAN',
                                  svgImage: KCardIcons.paymentMethod,
                                  iconColor: context.theme.appColors.primary,
                                  marginDistance: marginSize,
                                  onPressed: () async {
                                    final result =
                                        await Navigator.push<IbanModel>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddIbanDetailsPage(),
                                          ),
                                        );

                                    if (!context.mounted) return;

                                    if (result != null) {
                                      context.read<PaymentMethodBloc>().add(
                                        FetchPaymentMethodsEvent(),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if ((state.paymentMethods?.isEmpty ?? true))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.transparent,
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: SafeArea(
                      child: WattWhiteButton(
                        label: 'Complete later',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              if ((state.paymentMethods?.isNotEmpty ?? true))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.transparent,
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: SafeArea(
                      child: WattMainButton(
                        label: 'Done',
                        onPressed: () async {
                          context.read<OnboardingBloc>().add(
                            FetchUserPaymentMethodsEvent(),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
