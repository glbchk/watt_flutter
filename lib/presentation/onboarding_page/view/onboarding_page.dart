import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/add_your_car_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
// import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number/add_name_phone_number_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/add_payment_method_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_header_onboarding.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

import 'components/slim_card_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  String createLabel(String? name, String? phoneNumber) {
    if (name != null && phoneNumber != null) return '$name, $phoneNumber';
    if (name != null) return name;
    if (phoneNumber != null) return phoneNumber;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final double marginSize = 8.0;

        final cars = state.cars ?? [];
        final firstCar = cars.isNotEmpty ? cars.first : null;

        final chargingStations = state.chargingStations ?? [];
        final firstChargingStation = chargingStations.isNotEmpty
            ? chargingStations.first
            : null;

        String? firstPaymentMethod = 'No payment method';

        for (final paymentMethod in state.paymentMethods ?? []) {
          if (paymentMethod is CreditCardModel) {
            firstPaymentMethod = paymentMethod.cardNumber;
            break;
          } else if (paymentMethod is IbanModel) {
            firstPaymentMethod = paymentMethod.ibanNumber?.substring(0, 18);
            break;
          }
        }
        debugPrint(firstPaymentMethod);

        return Scaffold(
          backgroundColor: context.theme.appColors.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                TallHeaderOnboarding(
                  title: 'Welcome to Watt!',
                  label:
                      'We need details to provide a convenient\nWatt app experience for you',
                ),
                Transform.translate(
                  offset: Offset(0, -40),
                  child: Column(
                    children: [
                      SlimCardButton(
                        label: KCardTitles.addNameAndPhoneNumber,
                        subLabel: createLabel(state.name, state.phoneNumber),
                        svgImage: KCardIcons.profile,
                        marginDistance: marginSize,
                        iconColor:
                            state.name != null || state.phoneNumber != null
                            ? context.theme.appColors.onPrimary
                            : context.theme.appColors.grey2,
                        backgroundColor:
                            state.name != null || state.phoneNumber != null
                            ? context.theme.appColors.primary
                            : context.theme.appColors.surface,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddNameAndPhoneNumberPage(),
                            ),
                          );
                        },
                      ),
                      SlimCardButton(
                        label: KCardTitles.addCar,
                        subLabel: state.cars != null
                            ? createLabel(
                                firstCar?.brandName,
                                firstCar?.carModel,
                              )
                            : '',
                        svgImage: KCardIcons.car,
                        marginDistance: marginSize,
                        iconColor: state.cars != null
                            ? context.theme.appColors.onPrimary
                            : context.theme.appColors.grey2,
                        backgroundColor: state.cars != null
                            ? context.theme.appColors.primary
                            : context.theme.appColors.surface,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddYourCarPage(),
                            ),
                          );
                        },
                      ),
                      SlimCardButton(
                        label: KCardTitles.addChargingStation,
                        subLabel:
                            state.chargingStations != null &&
                                state.chargingStations!.isNotEmpty
                            ? firstChargingStation?.chargingStationName
                            : '',
                        svgImage: KCardIcons.chargingStation,
                        marginDistance: marginSize,
                        iconColor: state.chargingStations != null
                            ? context.theme.appColors.onPrimary
                            : context.theme.appColors.grey2,
                        backgroundColor: state.chargingStations != null
                            ? context.theme.appColors.primary
                            : context.theme.appColors.surface,
                        onPressed: () async {
                          // context.read<ChargingStationBloc>().add(
                          //   FetchUserChargingStationsEvent(),
                          // );

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => AddChargingStationPage(),
                          //   ),
                          // );

                          final result =
                              await Navigator.push<ChargingStationModel?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddChargingStationPage(),
                                ),
                              );

                          if (!context.mounted) return;

                          if (result != null) {
                            context.read<OnboardingBloc>().add(
                              FetchUserChargingStationsEvent(),
                            );
                          }
                        },
                      ),
                      SlimCardButton(
                        label: KCardTitles.addPaymentMethod,
                        subLabel:
                            state.paymentMethods != null &&
                                state.paymentMethods!.isNotEmpty
                            ? firstPaymentMethod
                            : '',
                        svgImage: KCardIcons.paymentMethod,
                        marginDistance: marginSize,
                        iconColor: state.paymentMethods != null
                            ? context.theme.appColors.onPrimary
                            : context.theme.appColors.grey2,
                        backgroundColor: state.paymentMethods != null
                            ? context.theme.appColors.primary
                            : context.theme.appColors.surface,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddPaymentMethodPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomFloatingButton(
            label: 'Complete later',
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNameAndPhoneNumberPage(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
