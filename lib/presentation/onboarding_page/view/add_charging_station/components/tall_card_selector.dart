import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/utils/colors.dart';

class TallCardSelector extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final String? svgImage;
  final String? pngImage;
  final Color? iconColor;
  final double? marginDistance;
  final Color? textColor;
  final Color? backgroundColor;

  const TallCardSelector({
    super.key,
    required this.label,
    this.onPressed,
    this.svgImage,
    this.pngImage,
    this.iconColor,
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
      child: Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: wattColorScheme.onSecondary.withAlpha(38),
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
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  child: svgImage != null
                      ? Container(
                          height: 60.0,
                          width: 60.0,
                          color: lightGreyColor,
                          child: Container(
                            margin: EdgeInsets.all(marginDistance ?? 0),
                            child: SvgPicture.asset(
                              svgImage ?? '',
                              colorFilter: ColorFilter.mode(
                                iconColor ?? greyAppColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 60.0,
                          width: 60.0,
                          color: lightGreyColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              pngImage ?? '',
                            ),
                          ),
                        ),
                ),

                SizedBox(width: 10.0),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: greyAppColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
