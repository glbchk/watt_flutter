import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/tall_card_selector.dart';
import 'package:watt/utils/constants.dart';

List<String> chargingEffectList = [
  KChargingEffect.three,
  KChargingEffect.seven,
  KChargingEffect.eleven,
  KChargingEffect.twentyTwo,
];

List<String> plugList = [
  KPlugs.threePhase,
  KPlugs.typeOne,
  KPlugs.typeTwo,
  KPlugs.wall,
];

class DetailBrandPropertyWidget extends StatefulWidget {
  const DetailBrandPropertyWidget({
    super.key,
  });

  @override
  State<DetailBrandPropertyWidget> createState() =>
      _DetailBrandPropertyWidgetState();
}

class _DetailBrandPropertyWidgetState extends State<DetailBrandPropertyWidget> {
  @override
  void dispose() {
    // controllerPriceKwh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            ...List.generate(
              chargingStationList.length,
              (index) {
                return TallCardSelector(
                  label: chargingStationList.elementAt(index),
                  pngImage: chargingStationIconsList.elementAt(index),
                  onPressed: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
