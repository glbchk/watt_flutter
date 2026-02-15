import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/add_charging_station_details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/constants.dart';

import '../components/short_header_onboarding.dart';

List<String> chargingStationList = [
  KChargingStationsNames.abb,
  KChargingStationsNames.easee,
  KChargingStationsNames.garo,
  KChargingStationsNames.vattenfall,
  KChargingStationsNames.tesla,
  KChargingStationsNames.other,
];

List<String> chargingStationIconsList = [
  KChargingStationsLogos.abb,
  KChargingStationsLogos.easee,
  KChargingStationsLogos.garo,
  KChargingStationsLogos.vattenfall,
  KChargingStationsLogos.tesla,
  KChargingStationsLogos.other,
];

List<String> daysList = [
  'M',
  'T',
  'W',
  'T',
  'F',
  'S',
  'S',
];

class AddChargingStationPage extends StatefulWidget {
  const AddChargingStationPage({super.key});

  @override
  State<AddChargingStationPage> createState() => _AddChargingStationPageState();
}

class _AddChargingStationPageState extends State<AddChargingStationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: ShortHeaderOnboarding(
                mainTitle: 'Add your charger station',
                subtitle: 'Select your charger',
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
                        chargingStationList.length,
                        (index) {
                          return TallCardButton(
                            label: chargingStationList.elementAt(index),
                            pngImage: chargingStationIconsList.elementAt(
                              index,
                            ),
                            onPressed: () {
                              final chargingStation = ChargingStationModel(
                                id: const Uuid().v4(),
                                brandName: chargingStationList[index],
                              );

                              context.read<OnboardingBloc>().add(
                                CreateChargingStationEvent(chargingStation),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddChargingStationDetailsPage(
                                    chargingStationId: chargingStation.id,
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
      },
    );
  }
}
