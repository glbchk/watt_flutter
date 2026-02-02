import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/select_car_model_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/constants.dart';

import '../components/short_header_onboarding.dart';

class AddYourCarPage extends StatefulWidget {
  const AddYourCarPage({super.key});

  @override
  State<AddYourCarPage> createState() => _AddYourCarPageState();
}

class _AddYourCarPageState extends State<AddYourCarPage> {
  List<String> carList = [
    KCarNames.audi,
    KCarNames.bmw,
    KCarNames.tesla,
    KCarNames.volvo,
    KCarNames.chevrolet,
    KCarNames.nissan,
    KCarNames.nissan,
    KCarNames.nissan,
  ];

  List<String> onboardingIconsList = [
    KCarLogos.audi,
    KCarLogos.bmw,
    KCarLogos.tesla,
    KCarLogos.volvo,
    KCarLogos.chevrolet,
    KCarLogos.nissan,
    KCarLogos.nissan,
    KCarLogos.nissan,
  ];

  @override
  Widget build(BuildContext context) {
    final double marginSize = 10.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: ShortHeaderOnboarding(
            mainTitle: 'Add your car',
            subtitle: 'Select your car',
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackgroundGradient(
              bgHeight: 0.28,
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Column(
                children: [
                  ...List.generate(
                    carList.length,
                    (index) {
                      return TallCardButton(
                        label: carList.elementAt(index),
                        pngImage: onboardingIconsList.elementAt(index),
                        marginDistance: marginSize,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectCarModelPage(
                                brandName: carList.elementAt(index),
                              ),
                            ),
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
    );
  }
}
