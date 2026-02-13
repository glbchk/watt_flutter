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
  final String selectedBrand;
  final ValueChanged<String> onPressed;

  const DetailBrandPropertyWidget({
    super.key,
    required this.selectedBrand,
    required this.onPressed,
  });

  @override
  State<DetailBrandPropertyWidget> createState() =>
      _DetailBrandPropertyWidgetState();
}

class _DetailBrandPropertyWidgetState extends State<DetailBrandPropertyWidget> {
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
                final brandName = chargingStationList.elementAt(index);

                return TallCardSelector(
                  label: chargingStationList.elementAt(index),
                  pngImage: chargingStationIconsList.elementAt(index),
                  isSelected: widget.selectedBrand == brandName,
                  onPressed: () => widget.onPressed(brandName),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
