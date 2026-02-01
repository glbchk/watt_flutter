import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class BackgroundGradient extends StatefulWidget {
  final LinearGradient backgroundColor = wattGradient;
  final double bgHeight;

  const BackgroundGradient({
    super.key,
    required this.bgHeight,
  });

  @override
  State<BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<BackgroundGradient> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarHeight = Scaffold.of(context).appBarMaxHeight?.toDouble() ?? 0;
    final heightForTitle = appBarHeight; //+ 40.0;

    return Container(
      height: MediaQuery.of(context).size.height * widget.bgHeight,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        top: heightForTitle,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     SizedBox(
      //       height: 50.0,
      //     ),
      //   ],
      // ),
    );
  }
}
