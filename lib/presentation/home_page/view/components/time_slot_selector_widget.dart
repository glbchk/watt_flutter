import 'package:flutter/material.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class TimeSlotSelectorWidget extends StatefulWidget {
  final List<TimeSlotModel>? slots;
  final Set<String> selectedSlots;
  final Function(String timeSlot) onToggle;

  const TimeSlotSelectorWidget({
    super.key,
    required this.slots,
    required this.selectedSlots,
    required this.onToggle,
  });

  @override
  State<TimeSlotSelectorWidget> createState() => _TimeSlotSelectorWidgetState();
}

class _TimeSlotSelectorWidgetState extends State<TimeSlotSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    List<SlotModel>? convertedSlots = [];
    for (final slot in widget.slots ?? []) {
      final generated = StringHelperMethods.generate30MinuteSlots(
        slot.startTime ?? '',
        slot.endTime ?? '',
      );

      convertedSlots.addAll(generated);
    }

    final List<SlotModel> _slots = convertedSlots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHOOSE TIME SLOT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Column(
              children: List.generate(_slots.length, (index) {
                final slot = _slots[index];
                final isSelected = widget.selectedSlots.contains(
                  slot.timeSlot,
                );
                final isLast = index == _slots.length - 1;

                return Column(
                  children: [
                    Material(
                      color: slot.isBusy ? Colors.grey.shade100 : Colors.white,
                      child: InkWell(
                        onTap: () => widget.onToggle(slot.timeSlot ?? ''),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                slot.timeSlot ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: slot.isBusy
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                                ),
                              ),
                              if (slot.isBusy)
                                Text(
                                  'Busy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              else if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
