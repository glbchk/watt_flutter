import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

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

class DetailNamePropertyWidget extends StatefulWidget {
  final TextEditingController controllerName;

  const DetailNamePropertyWidget({
    super.key,
    required this.controllerName,
  });

  @override
  State<DetailNamePropertyWidget> createState() =>
      _DetailNamePropertyWidgetState();
}

class _DetailNamePropertyWidgetState extends State<DetailNamePropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'This name will be visible for other users on the\n map in the Watt app',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              controller: widget.controllerName,
              label: 'Name',
              hint: "e.g. John's Amp",
            ),
          ],
        ),
      ),
    );
  }
}
