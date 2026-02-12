import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
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

class DetailAvailableHoursPropertyWidget extends StatefulWidget {
  final VoidCallback onPress;

  const DetailAvailableHoursPropertyWidget({
    super.key,
    required this.onPress,
  });

  @override
  State<DetailAvailableHoursPropertyWidget> createState() =>
      _DetailAvailableHoursPropertyWidgetState();
}

class _DetailAvailableHoursPropertyWidgetState
    extends State<DetailAvailableHoursPropertyWidget> {
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timeslot'.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: greyAppColor,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: wattColorScheme.onSecondary.withAlpha(38),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      ...List.generate(
                        daysList.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            child: ClipOval(
                              child: Container(
                                width: 35,
                                height: 35,
                                color: wattColorScheme.surface,
                                child: Center(
                                  child: Text(
                                    daysList[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: borderTFColor,
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: wattBlackColor,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: borderTFColor,
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'End',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: wattBlackColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            WattMainButton(
              label: 'Add timeslot',
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
