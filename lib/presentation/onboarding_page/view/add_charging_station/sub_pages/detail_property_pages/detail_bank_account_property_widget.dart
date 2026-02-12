import 'package:flutter/material.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

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

class DetailBankAccountPropertyWidget extends StatefulWidget {
  final VoidCallback onPress;

  const DetailBankAccountPropertyWidget({
    super.key,
    required this.onPress,
  });

  @override
  State<DetailBankAccountPropertyWidget> createState() =>
      _DetailBankAccountPropertyWidgetState();
}

class _DetailBankAccountPropertyWidgetState
    extends State<DetailBankAccountPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose IBAN or add new one to recieve earnings\n from your charging station',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            WattMainButton(
              label: 'Add IBAN',
              backgroundColor: Colors.white,
              textColor: wattBlackColor,
              onPressed: widget.onPress,
            ),
          ],
        ),
      ),
    );
  }
}
