import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/add_charging_station_page.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

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
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timeslot'.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.theme.appColors.grey1,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                color: context.theme.appColors.background,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.appColors.onSecondary.withAlpha(38),
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
                                color: context.theme.appColors.surface,
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
                    color: context.theme.appColors.grey3,
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
                          color: context.theme.appColors.onSurface,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: context.theme.appColors.grey3,
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
                          color: context.theme.appColors.onSurface,
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
            WattWhiteButton(
              label: 'Add timeslot',
              textColor: context.theme.appColors.onSurface,
              onPressed: widget.onPress,
            ),
          ],
        ),
      ),
    );
  }
}
