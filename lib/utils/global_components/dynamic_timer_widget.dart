import 'dart:async';

import 'package:flutter/material.dart';

class DynamicTimerWidget extends StatefulWidget {
  final int initialMinutes;
  const DynamicTimerWidget({super.key, required this.initialMinutes});

  @override
  State<DynamicTimerWidget> createState() => _DynamicTimerWidgetState();
}

class _DynamicTimerWidgetState extends State<DynamicTimerWidget> {
  Timer? _timer;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialMinutes * 60;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_secondsRemaining),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
