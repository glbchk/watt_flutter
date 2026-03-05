import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/small_textfield.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

import '../../../../../../utils/colors.dart';

class DetailAvailableHoursPropertyPage extends StatefulWidget {
  // final VoidCallback onPress;
  // final TextEditingController controllerStartTime;
  // final TextEditingController controllerEndTime;

  const DetailAvailableHoursPropertyPage({
    super.key,
    // required this.onPress,
    // required this.controllerStartTime,
    // required this.controllerEndTime,
  });

  @override
  State<DetailAvailableHoursPropertyPage> createState() =>
      _DetailAvailableHoursPropertyPageState();
}

class _DetailAvailableHoursPropertyPageState
    extends State<DetailAvailableHoursPropertyPage> {
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  List<int> _chosenDays = [];

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Available hours',
      content: Container(
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
                        KChargingStation.daysList.length,
                        (index) {
                          final int dayKey = KChargingStation.daysList.keys
                              .elementAt(index);
                          final String dayLabel =
                              KChargingStation.daysList[dayKey]?.substring(
                                0,
                                1,
                              ) ??
                              '';
                          final bool isSelected = _chosenDays.contains(dayKey);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                                            ? context.theme.appColors.onPrimary
                                            : context.theme.appColors.onSurface,
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
                        SmallTextField(
                          hint: '08:00',
                          controller: controllerStartTime,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            TimeSlotFormatter(),
                          ],
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
                        SmallTextField(
                          hint: '17:00',
                          controller: controllerEndTime,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            TimeSlotFormatter(),
                          ],
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
                // final String selectedDays = formatDayRanges(_chosenDays);

                final timeSlot = TimeSlotModel(
                  id: Uuid().v4(),
                  availableDays: _chosenDays,
                  startTime: controllerStartTime.text,
                  endTime: controllerEndTime.text,
                );

                context.read<ChargingStationBloc>().add(
                  AddTimeSlotEvent(timeSlot),
                );
                Navigator.pop(context, timeSlot);
              },
            ),
          ],
        ),
      ),
      onPressed: () {},
    );
  }
}

class TimeSlotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String hours = '';
    String minutes = '';

    if (digits.length >= 1) {
      hours = digits.substring(0, digits.length >= 2 ? 2 : 1);
    }

    if (digits.length >= 3) {
      minutes = digits.substring(2);
    }

    if (hours.length == 2) {
      int h = int.tryParse(hours) ?? 0;
      if (h > 23) {
        hours = '23';
      }
    }

    if (minutes.length == 2) {
      int m = int.tryParse(minutes) ?? 0;
      if (m > 59) {
        minutes = '59';
      }
    }

    String formatted = hours;

    if (minutes.isNotEmpty) {
      formatted += ':$minutes';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
