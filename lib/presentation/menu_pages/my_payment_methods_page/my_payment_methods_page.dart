import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/my_payment_methods_page/bloc/my_payment_methods_cubit.dart';
import 'package:watt/presentation/menu_pages/my_payment_methods_page/bloc/my_payment_methods_state.dart';
import 'package:watt/presentation/menu_pages/my_payment_methods_page/sub_pages/credit_card_details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/empty_tall_card_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class MyPaymentMethodsPage extends StatefulWidget {
  const MyPaymentMethodsPage({super.key});

  @override
  State<MyPaymentMethodsPage> createState() => _MyPaymentMethodsPageState();
}

class _MyPaymentMethodsPageState extends State<MyPaymentMethodsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyPaymentMethodsCubit>().fetchPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPaymentMethodsCubit, MyPaymentMethodsState>(
      builder: (context, state) {
        final double marginSize = 10.0;

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: Stack(
            children: [
              CustomScrollView(
                physics: ClampingScrollPhysics(),
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
                                'My payment methods',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Here you can see your payment methods',
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
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                          ),
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height / 1.27,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.paymentMethods != null &&
                                    state.paymentMethods!.isNotEmpty) ...[
                                  Column(
                                    spacing: 10,
                                    children: [
                                      ...state.paymentMethods!.map((
                                        paymentMethod,
                                      ) {
                                        return TallCardButton(
                                          isDismissible: true,
                                          dismissableKey: paymentMethod.id,
                                          onDismissableDismissed: () {
                                            context
                                                .read<MyPaymentMethodsCubit>()
                                                .removeCreditCard(
                                                  paymentMethod.id,
                                                );
                                          },
                                          label: paymentMethod.cardName ?? '',
                                          subLabel:
                                              paymentMethod
                                                  .isDefaultPaymentMethod
                                              ? "${paymentMethod.cardNumber ?? ''} • Default"
                                              : paymentMethod.cardNumber ?? '',
                                          svgImage: paymentMethod.networkLogo,
                                          marginDistance: marginSize,
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (_) =>
                                            //         ChargingStationDetailsPage(),
                                            //   ),
                                            // );
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ] else ...[
                                  EmptyTallCardButton(
                                    label: 'No charger stations added',
                                    subLabel: 'Please add your charger below',
                                    marginDistance: marginSize,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 34,
                child: WattWhiteButton(
                  label: 'Add payment method',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreditCardDetailsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
