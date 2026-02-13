import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/utils/colors.dart';

class TallCardSelector extends StatelessWidget {
  final String label;
  final String? svgImage;
  final String? pngImage;
  final Color? iconColor;
  final double? marginDistance;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isSelected;
  final VoidCallback? onPressed;

  const TallCardSelector({
    super.key,
    required this.label,
    this.svgImage,
    this.pngImage,
    this.iconColor,
    this.marginDistance,
    this.textColor,
    this.backgroundColor,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 5.0,
          right: 20.0,
          bottom: 5.0,
        ),
        child: Container(
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: wattColorScheme.onSecondary.withAlpha(38),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
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
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
