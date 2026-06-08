import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/status_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class MapPopupWidget extends StatelessWidget {
  final ChargingStationType chargingStationType;
  final String? stationStatus;
  final String? chargingStationName;
  final String? timeAvailability;
  final String? chargingStationAddress;
  final String? distanceToChargingStation;
  final String? plugType;
  final String? chargingEffect;
  final String? pricePerKwh;
  final VoidCallback? onPressedMoreDetails;
  final VoidCallback? onPressedToBook;
  final VoidCallback? onPressedPublicCharger;
  final VoidCallback? onPressedMyStation;
  final String? singleButtonLabel;

  const MapPopupWidget({
    super.key,
    required this.chargingStationType,
    this.stationStatus,
    this.chargingStationName,
    this.timeAvailability,
    this.chargingStationAddress,
    this.distanceToChargingStation,
    this.plugType,
    this.chargingEffect,
    this.pricePerKwh,
    this.onPressedMoreDetails,
    this.onPressedToBook,
    this.onPressedPublicCharger,
    this.onPressedMyStation,
    this.singleButtonLabel,
  });

  static Future<void> show({
    required BuildContext context,
    required ChargingStationModel station,
    String? stationStatus,
    String? chargingStationName,
    String? timeAvailability,
    String? chargingStationAddress,
    String? distanceToChargingStation,
    String? plugType,
    String? chargingEffect,
    String? pricePerKwh,
    VoidCallback? onPressedMoreDetails,
    VoidCallback? onPressedToBook,
    VoidCallback? onPressedPublicCharger,
    VoidCallback? onPressedMyStation,
    String? singleButtonLabel,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (popupContext) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return MapPopupWidget(
              chargingStationType: station.type ?? ChargingStationType.private,
              chargingStationName: station.chargingStationName,
              timeAvailability: station.availableHours?.isNotEmpty ?? false
                  ? "${StringHelperMethods.convertTimeSlotsToTimeRange(station.availableHours ?? [])}"
                  : 'No available time',
              chargingStationAddress: station.address,
              distanceToChargingStation: distanceToChargingStation,
              plugType: station.plug,
              chargingEffect: station.chargingEffect,
              pricePerKwh: station.pricePerKwh,
              onPressedMoreDetails: onPressedMoreDetails,
              onPressedToBook: onPressedToBook,
              onPressedPublicCharger: onPressedPublicCharger,
              onPressedMyStation: onPressedMyStation,
              stationStatus: stationStatus,
              singleButtonLabel: singleButtonLabel,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
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
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            right: 20.0,
          ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          chargingStationName ?? 'Charging Station Here',
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
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 8,
                    children: [
                      StatusWidget(label: stationStatus),
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
                      Expanded(
                        child: Text(
                          chargingStationAddress ??
                              'Kilowatt street 9, Stockholm, 12321',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
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
              chargingStationType == ChargingStationType.private
                  ? Row(
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
                              pricePerKwh != null
                                  ? "$pricePerKwh SEK/kWh"
                                  : '2 SEK/kWh',
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
                    )
                  : Row(
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
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              chargingStationType == ChargingStationType.private &&
                      singleButtonLabel != 'Your stations'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: WattWhiteButton(
                            label: 'More details',
                            textScaler: TextScaler.linear(0.85),
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
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: WattWhiteButton(
                            label: singleButtonLabel ?? 'Public Charger',
                            textScaler: TextScaler.linear(0.85),
                            noShadow: false,
                            onPressed: () {
                              if (singleButtonLabel != null) {
                                onPressedMyStation?.call();
                              } else {
                                onPressedPublicCharger?.call();
                              }
                            },
                          ),
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
