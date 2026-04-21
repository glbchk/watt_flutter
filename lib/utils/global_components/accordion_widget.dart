import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class AccordionWidget extends StatefulWidget {
  final String label;
  final String? secondLabel;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final IconData? icon;

  const AccordionWidget({
    super.key,
    required this.label,
    this.secondLabel,
    this.onPressed,
    this.isLoading,
    this.icon,
  });

  @override
  State<AccordionWidget> createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget> {
  bool isCollapsed = true;

  void toggle() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 20),
        // height: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.theme.appColors.grey3,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      widget.label,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.theme.appColors.onSurface,
                      ),
                    ),
                    if (!isCollapsed)
                      Text(
                        widget.secondLabel ?? '',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: context.theme.appColors.grey1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: isCollapsed ? 0 : 0.5,
              child: Icon(
                Icons.arrow_drop_down,
                color: isCollapsed
                    ? context.theme.appColors.grey1
                    : context.theme.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
