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
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingInitialState) {}
        if (state is OnboardingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final double marginSize = 8.0;

        final isNamePhoneNumberChanged = state is ToggleNamePhoneNumberState
            ? state.isNamePhoneNumberChanged
            : false;

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
                        svgImage: KCardIcons.profile,
                        marginDistance: marginSize,
                        backgroundColor: isNamePhoneNumberChanged
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
                        svgImage: KCardIcons.car,
                        marginDistance: marginSize,
                        backgroundColor: isNamePhoneNumberChanged
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
                        svgImage: KCardIcons.chargingStation,
                        marginDistance: marginSize,
                        backgroundColor: isNamePhoneNumberChanged
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
                        svgImage: KCardIcons.paymentMethod,
                        marginDistance: marginSize,
                        backgroundColor: isNamePhoneNumberChanged
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
