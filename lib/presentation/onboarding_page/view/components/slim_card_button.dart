import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/utils/colors.dart';

class SlimCardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final String? svgImage;
  final String? pngImage;
  final Color? iconColor = hintTextColor;
  final double? marginDistance;
  final Color? textColor;
  final Color? backgroundColor;

  const SlimCardButton({
    super.key,
    required this.label,
    this.onPressed,
    this.svgImage,
    this.pngImage,
    this.marginDistance,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 2.0,
        right: 20.0,
        bottom: 2.0,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 80.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: wattColorScheme.onSecondary.withAlpha(32),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      color: backgroundColor,
                      child: svgImage != null
                          ? Container(
                              margin: EdgeInsets.all(marginDistance ?? 0),
                              child: SvgPicture.asset(
                                svgImage ?? '',
                                colorFilter: ColorFilter.mode(
                                  iconColor ?? lightGreyColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.all(marginDistance ?? 0),
                              child: Image.asset(pngImage ?? ''),
                            ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: greyAppColor,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: iconColor,
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
