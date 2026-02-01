import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_your_car_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_header_onboarding.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

import 'components/card_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> onboardingTitlesList = [
      KCardTitles.addNameAndPhoneNumber,
      KCardTitles.addCar,
      KCardTitles.addChargingStation,
      KCardTitles.addPaymentMethod,
    ];
    List<IconData> onboardingIconsList = [
      KCardIcons.profile,
      KCardIcons.car,
      KCardIcons.chargingStation,
      KCardIcons.paymentMethod,
    ];

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingInitialState) {}
      },
      builder: (context, state) {
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
                      ...List.generate(
                        onboardingTitlesList.length,
                        (index) {
                          return CardButton(
                            label: onboardingTitlesList.elementAt(index),
                            frontIcon: onboardingIconsList.elementAt(index),
                            onPressed: () {
                              assignCardAction(
                                context,
                                onboardingTitlesList.elementAt(index),
                              );
                            },
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

void assignCardAction(BuildContext context, String cardTitle) {
  switch (cardTitle) {
    case KCardTitles.addNameAndPhoneNumber:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddNameAndPhoneNumberPage(),
        ),
      );
      break;
    case KCardTitles.addCar:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddYourCarPage(),
        ),
      );
      break;
    case KCardTitles.addChargingStation:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddChargingStationPage(),
        ),
      );
      break;
    case KCardTitles.addPaymentMethod:
      // context.read<PaymentBloc>().add(SetupPaymentRequested());
      break;
    default:
      print("No action defined for $cardTitle");
  }
}
