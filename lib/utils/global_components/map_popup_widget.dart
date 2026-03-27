import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class MapPopupWidget extends StatelessWidget {
  final String? chargingStationName;
  final String? timeAvailability;
  final String? chargingStationAddress;
  final String? distanceToChargingStation;
  final String? plugType;
  final String? chargingEffect;
  final String? pricePerKwh;
  final VoidCallback? onPressedMoreDetails;
  final VoidCallback? onPressedToBook;

  const MapPopupWidget({
    super.key,
    this.chargingStationName,
    this.timeAvailability,
    this.chargingStationAddress,
    this.distanceToChargingStation,
    this.plugType,
    this.chargingEffect,
    this.pricePerKwh,
    this.onPressedMoreDetails,
    this.onPressedToBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: context.theme.appColors.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.onSecondary.withAlpha(
              38,
            ),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: context.theme.appColors.grey2,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      chargingStationName ?? 'Charging Station Here',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 8,
                  children: [
                    Container(
                      width: 75,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.theme.appColors.success,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      timeAvailability ?? '9:30-12:30',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              spacing: 5,
              children: [
                Divider(
                  height: 1,
                  color: context.theme.appColors.grey3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chargingStationAddress ??
                          'Kilowatt street 9, Stockholm, 12321',
                    ),
                    Container(
                      width: 62,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.theme.appColors.grey4,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        distanceToChargingStation ?? '8,7 km',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                  color: context.theme.appColors.grey3,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  spacing: 5,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.theme.appColors.grey4,
                      ),
                      child: Icon(
                        size: 30,
                        Icons.settings_input_hdmi,
                        color: context.theme.appColors.primary,
                      ),
                    ),
                    Text(
                      plugType ?? 'Type 2',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 5,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.theme.appColors.grey4,
                      ),
                      child: Icon(
                        size: 30,
                        Icons.bolt,
                        color: context.theme.appColors.primary,
                      ),
                    ),
                    Text(
                      chargingEffect ?? '11 kW',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 5,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: context.theme.appColors.grey4,
                      ),
                      child: Icon(
                        size: 30,
                        Icons.paid,
                        color: context.theme.appColors.primary,
                      ),
                    ),
                    Text(
                      pricePerKwh ?? '2 SEK/kWh',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: WattWhiteButton(
                    label: 'More details',
                    textScaler: TextScaler.linear(0.9),
                    onPressed: () {
                      onPressedMoreDetails?.call();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: WattMainButton(
                    label: 'Book',
                    onPressed: () {
                      onPressedToBook?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
