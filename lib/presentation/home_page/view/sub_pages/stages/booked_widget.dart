import 'package:flutter/material.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/line_card_widget.dart';

class BookedWidget extends StatefulWidget {
  final List<TimeSlotModel>? timeSlots;
  final Set<String> selectedSlots;

  const BookedWidget({
    super.key,
    this.timeSlots,
    required this.selectedSlots,
  });

  @override
  State<BookedWidget> createState() => _BookedWidgetState();
}

class _BookedWidgetState extends State<BookedWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
