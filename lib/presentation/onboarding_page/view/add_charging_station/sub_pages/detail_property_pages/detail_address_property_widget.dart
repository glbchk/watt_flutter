import 'package:flutter/material.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/inline_button.dart';

import '../../../../../../utils/colors.dart';

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

class DetailAddressPropertyWidget extends StatefulWidget {
  final TextEditingController controllerAddress;
  final VoidCallback? onPressedCurrentLocation;
  final VoidCallback? onPressedChooseOnMap;

  const DetailAddressPropertyWidget({
    super.key,
    required this.controllerAddress,
    this.onPressedCurrentLocation,
    this.onPressedChooseOnMap,
  });

  @override
  State<DetailAddressPropertyWidget> createState() =>
      _DetailAddressPropertyWidgetState();
}

class _DetailAddressPropertyWidgetState
    extends State<DetailAddressPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: widget.controllerAddress,
              prefixIcon: Icon(Icons.search),
              prefixIconColor: context.theme.appColors.grey1,
              label: 'Name',
              hint: "e.g. John's Amp",
            ),
            SizedBox(
              height: 20.0,
            ),
            InlineButton(
              label: 'Use my current location',
              icon: Icons.my_location,
              onPressed: widget.onPressedCurrentLocation,
            ),
            InlineButton(
              label: 'Choose location on map',
              icon: Icons.location_on_outlined,
              onPressed: widget.onPressedChooseOnMap,
            ),
          ],
        ),
      ),
    );
  }
}
