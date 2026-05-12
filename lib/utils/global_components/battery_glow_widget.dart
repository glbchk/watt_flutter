import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watt/utils/colors.dart';

class BatteryGlow extends StatefulWidget {
  const BatteryGlow({super.key});

  @override
  State<BatteryGlow> createState() => _BatteryGlowState();
}

class _BatteryGlowState extends State<BatteryGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 4, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.1, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.theme.appColors.success.withValues(alpha: 0.01),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.appColors.success.withValues(
                      alpha: _opacityAnimation.value * 0.4,
                    ),
                    blurRadius: _animation.value * 1.5,
                    spreadRadius: _animation.value * 1.2,
                  ),
                  BoxShadow(
                    color: context.theme.appColors.success.withValues(
                      alpha: _opacityAnimation.value * 0.6,
                    ),
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value * 0.2,
                  ),
                ],
              ),
            ),

            SvgPicture.asset(
              'assets/images/battery.svg',
              width: 60,
              height: 100,
            ),
          ],
        );
      },
    );
  }
}
