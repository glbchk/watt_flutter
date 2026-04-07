import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/enum/reservation_stage_enum.dart';
import 'package:watt/presentation/home_page/view/components/time_slot_selector_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/line_card_widget.dart';

class ChargingWidget extends StatefulWidget {
  final ReservationStage stage;
  final List<TimeSlotModel>? timeSlots;
  final Set<String> selectedSlots;

  const ChargingWidget({
    super.key,
    required this.stage,
    this.timeSlots,
    required this.selectedSlots,
  });

  @override
  State<ChargingWidget> createState() => _ChargingWidgetState();
}

class _ChargingWidgetState extends State<ChargingWidget> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.stage) {
      // TODO: Handle this case.
      ReservationStage.booking => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeSlotSelectorWidget(
            slots: widget.timeSlots,
            selectedSlots: widget.selectedSlots,
            onToggle: (slot) {
              context.read<HomeCubit>().toggleSlot(slot);
            },
          ),
          SizedBox(height: 30),
          Text(
            'Notes'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.appColors.grey1,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(
                color: context.theme.appColors.grey3,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    15.0,
                  ),
                  child: Text(
                    'Charger located on the left side of the house. See picture, 100% solar power',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
      ReservationStage.reservationRequested => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LineCardWidget(
            label: 'Booked Time',
            startTime: '2020-11-09, 8:00',
            endTime: '2020-11-09, 12:00',
          ),
          SizedBox(height: 30),
          Text(
            'Notes'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.theme.appColors.grey1,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(
                color: context.theme.appColors.grey3,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    15.0,
                  ),
                  child: Text(
                    'Charger located on the left side of the house. See picture, 100% solar power',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
      // TODO: Handle this case.
      ReservationStage.booked => SizedBox(height: 200),
      // TODO: Handle this case.
      ReservationStage.charging => SizedBox(height: 200),
      // TODO: Handle this case.
      ReservationStage.publicCharger => SizedBox(height: 0),
    };
  }
}
