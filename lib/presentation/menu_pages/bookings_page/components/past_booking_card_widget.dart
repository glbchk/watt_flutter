import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class PastReservationCardWidget extends StatelessWidget {
  final String? customerName;
  final String? startTimeOfReservation;
  final String? endTimeOfReservation;
  final VoidCallback? onPressed;

  const PastReservationCardWidget({
    super.key,
    this.customerName,
    this.startTimeOfReservation,
    this.endTimeOfReservation,
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
                            startTimeOfReservation != null
                                ? 'Start - $startTimeOfReservation'
                                : 'Start - Fake 2020-11-09, 9:30',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            endTimeOfReservation != null
                                ? 'End - $endTimeOfReservation'
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
