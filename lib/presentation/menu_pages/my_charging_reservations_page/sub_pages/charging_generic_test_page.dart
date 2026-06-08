import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/data/models/reservation_model.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/battery_glow_widget.dart';
import 'package:watt/utils/global_components/charging_progress_bar_widget.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/dynamic_timer_widget.dart';
import 'package:watt/utils/global_components/status_widget.dart';
import 'package:watt/utils/global_components/watt_alert.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

///TODO: NEED TO BE MERGED WITH charging_page.dart AND FIXED
class ChargingTestPage<T extends Cubit<S>, S> extends StatefulWidget {
  final ReservationModel reservation;
  final BookingModel booking;
  final Duration duration;
  final Function(T) onInit;
  final Function(T, ReservationModel, BookingModel) onStopCharging;

  const ChargingTestPage({
    super.key,
    required this.reservation,
    required this.booking,
    required this.duration,
    required this.onInit,
    required this.onStopCharging,
  });

  @override
  State<ChargingTestPage<T, S>> createState() => _ChargingTestPageState<T, S>();
}

class _ChargingTestPageState<T extends Cubit<S>, S>
    extends State<ChargingTestPage<T, S>> {
  @override
  void initState() {
    super.initState();
    widget.onInit(context.read<T>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, S>(
      builder: (context, state) {
        final currentState = state as ReservationsState;

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          title: 'Charging page',
          titleColor: context.theme.appColors.onSecondary,
          appBarBackgroundColor: context.theme.appColors.background,
          scaffoldBackgroundColor: context.theme.appColors.background,
          leading: BackButton(
            color: context.theme.appColors.onSecondary,
            onPressed: () {
              // context.read<OnboardingBloc>().add(
              //   NameVerificationEvent(value: ''),
              // );
              // context.read<OnboardingBloc>().add(
              //   PhoneNumberVerificationEvent(value: ''),
              // );
              Navigator.of(context).pop();
            },
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 2,
                                      children: [
                                        Text(
                                          currentState
                                                  .reservedChargingStation
                                                  ?.chargingStationName ??
                                              'Charging Station Here',
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
                                        SizedBox(height: 6),
                                        StatusWidget(
                                          label:
                                              currentState
                                                  .reservedChargingStation
                                                  ?.stationStatus
                                                  ?.label ??
                                              'Status Unknown',
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/images/map_screenshot.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 8.0,
                                  ),
                                  child: Divider(
                                    height: 1,
                                    color: context.theme.appColors.grey3,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    Text(
                                      currentState
                                              .reservedChargingStation
                                              ?.address ??
                                          "John’s Amp",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: context.theme.appColors.grey3,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      30,
                                                    ),
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .grey4,
                                              ),
                                              child: Icon(
                                                size: 30,
                                                Icons.settings_input_hdmi,
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .primary,
                                              ),
                                            ),
                                            Text(
                                              currentState
                                                      .reservedChargingStation
                                                      ?.plug ??
                                                  'Type 2',
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      30,
                                                    ),
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .grey4,
                                              ),
                                              child: Icon(
                                                size: 30,
                                                Icons.bolt,
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .primary,
                                              ),
                                            ),
                                            Text(
                                              currentState
                                                      .reservedChargingStation
                                                      ?.chargingEffect ??
                                                  '11 kW',
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      30,
                                                    ),
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .grey4,
                                              ),
                                              child: Icon(
                                                size: 30,
                                                Icons.paid,
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .primary,
                                              ),
                                            ),
                                            Text(
                                              currentState
                                                          .reservedChargingStation
                                                          ?.pricePerKwh !=
                                                      null
                                                  ? "${currentState.reservedChargingStation?.pricePerKwh} SEK/kWh"
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: context.theme.appColors.grey3,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      spacing: 10,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'You are charging:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: context
                                                    .theme
                                                    .appColors
                                                    .grey1,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            DynamicTimerWidget(
                                              initialMinutes:
                                                  widget.duration.inMinutes,
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10),
                                        BatteryGlow(),

                                        ChargingProgressBarWidget(
                                          duration: widget.duration,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 34,
                child: WattWhiteButton(
                  label: 'Stop charging',
                  textColor: context.theme.appColors.error,
                  onPressed: () async {
                    // context.read<T>().stopChargingOrCancelReservation(
                    //   widget.reservation,
                    // );
                    WattAlertWidget.show(
                      context: context,
                      title: 'Stop charging',
                      message:
                          'By clicking Stop charging, your charging will be stopped and you will need to make a new reservation',
                      heightBetweenMessageAndTextfield: 0,
                      buttonLabel: 'Stop',
                      onConfirm: () {
                        widget.onStopCharging(
                          context.read<T>(),
                          widget.reservation,
                          widget.booking,
                        );
                        Navigator.pop(context);
                      },
                      cancelLabel: 'Cancel',
                      onCancelConfirm: () {
                        widget.onStopCharging(
                          context.read<T>(),
                          widget.reservation,
                          widget.booking,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
