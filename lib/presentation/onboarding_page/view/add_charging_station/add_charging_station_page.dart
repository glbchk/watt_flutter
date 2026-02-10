import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_details_page.dart';
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

class AddChargingStationPage extends StatefulWidget {
  const AddChargingStationPage({super.key});

  @override
  State<AddChargingStationPage> createState() => _AddChargingStationPageState();
}

class _AddChargingStationPageState extends State<AddChargingStationPage> {
  @override
  Widget build(BuildContext context) {
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
                        pngImage: chargingStationIconsList.elementAt(index),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddChargingStationDetailsPage(
                                chargingStationBrandName: chargingStationList
                                    .elementAt(
                                      index,
                                    ),
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
