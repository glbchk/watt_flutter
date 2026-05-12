import 'package:flutter/material.dart';
import 'package:watt/data/models/slot_model.dart';

class TimeSlotSelectorWidget extends StatefulWidget {
  final List<SlotModel> slots;
  final List<SlotModel> selectedSlots;
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
              children: List.generate(widget.slots.length, (index) {
                final slot = widget.slots[index];
                final isSelected = widget.selectedSlots.contains(
                  slot,
                );
                final isLast = index == widget.slots.length - 1;

                return Column(
                  children: [
                    Material(
                      color: slot.isBusy ? Colors.grey.shade100 : Colors.white,
                      child: InkWell(
                        onTap: slot.isBusy
                            ? null
                            : () => widget.onToggle(slot.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${slot.startTime} - ${slot.endTime}",
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
