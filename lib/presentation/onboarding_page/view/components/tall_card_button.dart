import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/utils/colors.dart';

class TallCardButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final String label;
  final String? subLabel;
  final String? subSubLabel;
  final VoidCallback? onPressed;
  final String? svgImage;
  final String? pngImage;
  final Color? iconColor;
  final double? marginDistance;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? isArrowIconVisible;

  const TallCardButton({
    super.key,
    this.padding,
    required this.label,
    this.subLabel,
    this.subSubLabel,
    this.onPressed,
    this.svgImage,
    this.pngImage,
    this.iconColor,
    this.marginDistance,
    this.textColor,
    this.backgroundColor,
    this.isArrowIconVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.only(
            left: 20.0,
            top: 2.0,
            right: 20.0,
            bottom: 2.0,
          ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: context.theme.appColors.onSecondary.withAlpha(38),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            color: context.theme.appColors.background,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    child: svgImage != null
                        ? Container(
                            height: 60.0,
                            width: 60.0,
                            color: context.theme.appColors.grey4,
                            child: Container(
                              margin: EdgeInsets.all(marginDistance ?? 0),
                              child: SvgPicture.asset(
                                svgImage ?? '',
                                colorFilter: ColorFilter.mode(
                                  iconColor ?? context.theme.appColors.grey1,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 60.0,
                            width: 60.0,
                            color: context.theme.appColors.grey4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                pngImage ?? '',
                              ),
                            ),
                          ),
                  ),

                  SizedBox(width: 10.0),
                  subLabel == null
                      ? Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      : subSubLabel == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              subLabel ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.theme.appColors.grey1,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              subLabel ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.theme.appColors.grey1,
                              ),
                            ),
                            Text(
                              subSubLabel ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.theme.appColors.grey1,
                              ),
                            ),
                          ],
                        ),
                  Spacer(),
                  if (isArrowIconVisible ?? true)
                    Icon(
                      Icons.chevron_right,
                      color: context.theme.appColors.grey1,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
