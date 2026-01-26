import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/components/header_onboarding.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

import 'components/card_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> cardList = [
      KCards.addNameAndPhoneNumber,
      KCards.addCar,
      KCards.addChargingStation,
      KCards.addPaymentMethod,
    ];
    List<IconData> iconList = [
      KIcons.profile,
      KIcons.car,
      KIcons.chargingStation,
      KIcons.paymentMethod,
    ];

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderOnboarding(
              title: 'Welcome to Watt!',
              label:
                  'We need details to provide a convenient\nWatt app experience for you',
            ),
            Transform.translate(
              offset: Offset(0, -30),
              child: Column(
                children: [
                  ...List.generate(
                    cardList.length,
                    (index) {
                      return CardButton(
                        label: cardList.elementAt(index),
                        frontIcon: iconList.elementAt(index),
                        onPressed: () {},
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
        callback: () {},
      ),
    );
  }
}
