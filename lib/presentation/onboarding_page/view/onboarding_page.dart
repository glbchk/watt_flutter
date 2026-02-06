import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/add_your_car_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number/add_name_phone_number_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/add_payment_method_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_header_onboarding.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

import 'components/slim_card_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final double marginSize = 8.0;

        return Scaffold(
          // extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          // ),
          backgroundColor: Colors.white,
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
                        subLabel:
                            '${state.name ?? ''}, ${state.phoneNumber ?? ''}',
                        svgImage: KCardIcons.profile,
                        marginDistance: marginSize,
                        backgroundColor: state.isNameValid
                            ? wattColorScheme.onPrimary
                            : lightGreyColor,
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
                        subLabel: KCardTitles.addCar,
                        svgImage: KCardIcons.car,
                        marginDistance: marginSize,
                        backgroundColor: state.isPhoneNumberValid
                            ? wattColorScheme.onPrimary
                            : lightGreyColor,
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
                        subLabel: KCardTitles.addChargingStation,
                        svgImage: KCardIcons.chargingStation,
                        marginDistance: marginSize,
                        backgroundColor: state.isNameValid
                            ? wattColorScheme.onPrimary
                            : lightGreyColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddChargingStationPage(),
                            ),
                          );
                        },
                      ),
                      SlimCardButton(
                        label: KCardTitles.addPaymentMethod,
                        subLabel: KCardTitles.addPaymentMethod,
                        svgImage: KCardIcons.paymentMethod,
                        marginDistance: marginSize,
                        backgroundColor: state.isNameValid
                            ? wattColorScheme.onPrimary
                            : lightGreyColor,
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
