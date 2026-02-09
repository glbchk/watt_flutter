import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/select_car_model_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

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
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final double marginSize = 10.0;

        // if (state.cars != null) {
        //   addedCars.add(state.cars ?? CarModel());
        // }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.cars != null && state.cars!.isNotEmpty) ...[
                        ...state.cars!.map((car) {
                          return TallCardButton(
                            label: car.brandName ?? '',
                            pngImage: onboardingIconsList[0],
                            marginDistance: marginSize,
                            onPressed: () {},
                          );
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
                              color: greyAppColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                      ],
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
          bottomNavigationBar: (state.cars?.isEmpty ?? false)
              ? const SizedBox()
              : BottomFloatingButton(
                  label: 'Save',
                  callback: () {},

                  ///TODO: Need to fix color and update the BottomFloatingButton
                  ///to have different styles through ENUM
                ),
        );
      },
    );
  }
}
