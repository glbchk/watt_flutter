import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/small_textfield.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';
import 'package:watt/utils/global_methods/custom_input_formatters.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';
import 'package:watt/utils/global_methods/textfield_helper_methods.dart';

class AddStationAvailableHoursDetailsPage extends StatefulWidget {
  const AddStationAvailableHoursDetailsPage({
    super.key,
  });

  @override
  State<AddStationAvailableHoursDetailsPage> createState() =>
      _AddStationAvailableHoursDetailsPageState();
}

class _AddStationAvailableHoursDetailsPageState
    extends State<AddStationAvailableHoursDetailsPage> {
  final double marginSize = 15.0;

  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  List<int> _chosenDays = [];

  final startFocus = FocusNode();
  final endFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    startFocus.addListener(() {
      if (!startFocus.hasFocus) {
        TextfieldHelperMethods.completeTimeFormatting(controllerStartTime);
      }
    });

    endFocus.addListener(() {
      if (!endFocus.hasFocus) {
        TextfieldHelperMethods.completeTimeFormatting(controllerEndTime);
      }
    });
  }

  @override
  void dispose() {
    startFocus.dispose();
    endFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChargingStationsCubit, MyChargingStationsState>(
      builder: (context, state) {
        final slots = state.chargingStation?.availableHours ?? [];

        return DetailsWidget(
          title: 'Available hours',
          content: Container(
            color: context.theme.appColors.background,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (slots.isNotEmpty)
                  Text(
                    'Added Timeslots'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.theme.appColors.grey1,
                    ),
                  ),
                if (slots.isNotEmpty) SizedBox(height: 8.0),
                if (slots.isNotEmpty)
                  Column(
                    spacing: 10,
                    children: [
                      ...List.generate(
                        state.chargingStation?.availableHours?.length ?? 0,
                        (index) {
                          final TimeSlotModel? timeSlot = state
                              .chargingStation
                              ?.availableHours
                              ?.elementAt(
                                index,
                              );

                          return TallCardButton(
                            isDismissible: true,
                            dismissableKey: timeSlot?.id,
                            onDismissableDismissed: () {
                              context
                                  .read<MyChargingStationsCubit>()
                                  .removeTimeSlot(timeSlot?.id ?? '');
                            },
                            padding: EdgeInsets.only(top: 2, bottom: 2),
                            label: StringHelperMethods.formatDayRanges(
                              timeSlot?.availableDays,
                            ),
                            subLabel:
                                '${timeSlot?.startTime} - ${timeSlot?.endTime}',
                            svgImage: KCardIcons.timeSlot,
                            iconColor: context.theme.appColors.primary,
                            marginDistance: marginSize,
                          );
                        },
                      ),
                    ],
                  ),

                if (slots.isNotEmpty) SizedBox(height: 20.0),
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
                        color: context.theme.appColors.onSecondary.withAlpha(
                          38,
                        ),
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
                            KMockedData.daysList.length,
                            (index) {
                              final int dayKey = KMockedData.daysList.keys
                                  .elementAt(index);
                              final String dayLabel =
                                  KMockedData.daysList[dayKey]?.substring(
                                    0,
                                    1,
                                  ) ??
                                  '';
                              final bool isSelected = _chosenDays.contains(
                                dayKey,
                              );

                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 5.0,
                                ),
                                child: ClipOval(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _chosenDays.remove(dayKey);
                                        } else {
                                          _chosenDays.add(dayKey);
                                        }

                                        _chosenDays.sort();

                                        print(_chosenDays);
                                      });
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? context.theme.appColors.primary
                                            : context.theme.appColors.surface,
                                      ),
                                      child: Center(
                                        child: Text(
                                          dayLabel,
                                          style: TextStyle(
                                            color: isSelected
                                                ? context
                                                      .theme
                                                      .appColors
                                                      .onPrimary
                                                : context
                                                      .theme
                                                      .appColors
                                                      .onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          state.availableDaysError != null
                              ? Text(
                                  state.availableDaysError ?? '',
                                  style: TextStyle(
                                    color: context.theme.appColors.error,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                state.startTimeError != null
                                    ? Text(
                                        state.startTimeError ?? '',
                                        style: TextStyle(
                                          color: context.theme.appColors.error,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            SmallTextField(
                              hint: '08:00',
                              error: state.startTimeError,
                              controller: controllerStartTime,
                              focusNode: startFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TimeSlotFormatter(),
                              ],
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  state.endTimeError != null
                                      ? Text(
                                          state.endTimeError ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                context.theme.appColors.error,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),

                            SmallTextField(
                              hint: '17:00',
                              error: state.endTimeError,
                              controller: controllerEndTime,
                              focusNode: endFocus,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TimeSlotFormatter(),
                              ],
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
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
                  onPressed: () {
                    final timeSlot = TimeSlotModel(
                      id: Uuid().v4(),
                      availableDays: List.from(_chosenDays),
                      startTime: controllerStartTime.text,
                      endTime: controllerEndTime.text,
                    );

                    if ((timeSlot.availableDays?.isEmpty ?? true) ||
                        (timeSlot.startTime?.isEmpty ?? true) ||
                        (timeSlot.endTime?.isEmpty ?? true)) {
                      context
                          .read<MyChargingStationsCubit>()
                          .verifyAvailableHours(
                            _chosenDays,
                            controllerStartTime.text,
                            controllerEndTime.text,
                          );
                    } else {
                      context.read<MyChargingStationsCubit>().addTimeSlot(
                        timeSlot,
                      );

                      setState(() {
                        controllerStartTime.clear();
                        controllerEndTime.clear();
                        _chosenDays.clear();
                      });

                      FocusScope.of(context).unfocus();

                      context
                          .read<MyChargingStationsCubit>()
                          .verifyAvailableHours(
                            [1],
                            'valid',
                            'valid',
                          );
                    }
                  },
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context, state.chargingStation?.availableHours);
          },
        );
      },
    );
  }
}
