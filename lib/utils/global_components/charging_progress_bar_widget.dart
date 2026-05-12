import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class ChargingProgressBarWidget extends StatefulWidget {
  final Duration duration;

  const ChargingProgressBarWidget({
    super.key,
    required this.duration,
  });

  @override
  State<ChargingProgressBarWidget> createState() =>
      _ChargingProgressBarWidgetState();
}

class _ChargingProgressBarWidgetState extends State<ChargingProgressBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Column(
          children: [
            Text(
              '${(_controller.value * 100).toInt()}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.theme.appColors.onSecondary,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _controller.value,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
