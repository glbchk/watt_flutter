import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/view/components/time_slot_selector_widget.dart';
import 'package:watt/utils/colors.dart';

class ReservationBookingWidget extends StatefulWidget {
  final List<TimeSlotModel>? timeSlots;
  final Set<String> selectedSlots;

  const ReservationBookingWidget({
    super.key,
    this.timeSlots,
    required this.selectedSlots,
  });

  @override
  State<ReservationBookingWidget> createState() =>
      _ReservationBookingWidgetState();
}

class _ReservationBookingWidgetState extends State<ReservationBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
