import 'package:flutter/material.dart';

class BookingCardWidget extends StatelessWidget {
  final String? firstTabLabel;
  final String? secondTabLabel;
  final String? chargingStationTimeSlot;
  final String? chargingStationName;
  final VoidCallback? onPressedReject;
  final VoidCallback? onPressedAccept;
  final VoidCallback? onPressedContactUser;

  const BookingCardWidget({
    super.key,
    this.firstTabLabel,
    this.secondTabLabel,
    this.chargingStationTimeSlot,
    this.chargingStationName,
    this.onPressedReject,
    this.onPressedAccept,
    this.onPressedContactUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: TabBar(
        labelColor: const Color(
          0xFF007AFF,
        ),
        unselectedLabelColor: Colors.grey.shade400,
        indicatorColor: const Color(
          0xFF007AFF,
        ),
        indicatorWeight: 3.0,
        dividerColor: Colors.grey.shade300,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        tabs: [
          Tab(text: firstTabLabel ?? 'Upcoming'),
          Tab(text: secondTabLabel ?? 'Past'),
        ],
      ),
    );
  }
}
