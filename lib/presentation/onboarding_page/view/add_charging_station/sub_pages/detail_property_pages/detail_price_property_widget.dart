import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watt/utils/constants.dart';

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

class DetailPricePropertyWidget extends StatefulWidget {
  final TextEditingController controllerPrice;
  final String currency;

  const DetailPricePropertyWidget({
    super.key,
    required this.controllerPrice,
    this.currency = 'SEK',
  });

  @override
  State<DetailPricePropertyWidget> createState() =>
      _DetailPricePropertyWidgetState();
}

class _DetailPricePropertyWidgetState extends State<DetailPricePropertyWidget> {
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
              'This price will be visible for other users, who\n wants to book your charger',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.theme.appColors.grey1,
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 58,
                ),
                Expanded(
                  child: TextFormField(
                    controller: widget.controllerPrice,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 28, color: Colors.black),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: context.theme.appColors.grey3,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.appColors.grey3,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.appColors.primary,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.currency} / kWh',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  width: 58,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
