import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class PastBookingCardWidget extends StatelessWidget {
  final String? customerName;
  final String? startTimeOfBooking;
  final String? endTimeOfBooking;
  final VoidCallback? onPressed;

  const PastBookingCardWidget({
    super.key,
    this.customerName,
    this.startTimeOfBooking,
    this.endTimeOfBooking,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Container(
          color: context.theme.appColors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        customerName ?? 'Peter Name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            startTimeOfBooking != null
                                ? 'Start - $startTimeOfBooking'
                                : 'Start - Fake 2020-11-09, 9:30',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            endTimeOfBooking != null
                                ? 'End - $endTimeOfBooking'
                                : 'End - Fake 2020-11-09, 12:30',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: context.theme.appColors.grey1,
                  ),
                ],
              ),
              Divider(
                height: 1,
                color: context.theme.appColors.grey3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
