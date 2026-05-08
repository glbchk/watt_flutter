import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/text_icon_button.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class ReservationCardWidget extends StatelessWidget {
  final String? chargingStationName;
  final String? dateOfReservation;
  final String? chargingStationTimeSlot;
  final String? chargingStationAddress;
  final VoidCallback? onPressedReject;
  final VoidCallback? onPressedAccept;
  final VoidCallback? onPressedContactUser;
  final String? negativeLabel;
  final String? positiveLabel;
  final Color? positiveButtonColor;

  const ReservationCardWidget({
    super.key,
    this.chargingStationName,
    this.dateOfReservation,
    this.chargingStationTimeSlot,
    this.chargingStationAddress,
    this.onPressedReject,
    this.onPressedAccept,
    this.onPressedContactUser,
    this.negativeLabel,
    this.positiveLabel,
    this.positiveButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // width: double.infinity,
        height: 360,
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
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chargingStationName ?? 'No name found',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            size: 20,
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: context.theme.appColors.grey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      Text(
                        dateOfReservation ?? '2020-11-09',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        chargingStationTimeSlot ?? '9:30-12:30',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: context.theme.appColors.grey3,
                  ),
                  Text(
                    chargingStationAddress ?? "Address not found",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                spacing: 15,
                children: [
                  WattWhiteButton(
                    label: negativeLabel ?? 'Reject',
                    textColor: context.theme.appColors.error,
                    textScaler: TextScaler.linear(0.9),
                    onPressed: () {
                      onPressedReject?.call();
                    },
                  ),
                  WattMainButton(
                    label: positiveLabel ?? 'Accept',
                    backgroundColor:
                        positiveButtonColor ?? context.theme.appColors.success,
                    buttonShadow: context.theme.appColors.successShadow
                        .withAlpha(30),
                    onPressed: () {
                      onPressedAccept?.call();
                    },
                  ),
                  TextIconButton(
                    label: 'Contact user',
                    textScaler: TextScaler.linear(0.9),
                    onPressed: () {
                      onPressedContactUser?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
