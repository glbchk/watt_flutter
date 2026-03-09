import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class DefaultAppBar extends StatelessWidget {
  final bool? extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  final String? title;
  final Color? titleColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? foregroundColor;
  final Color? appBarBackgroundColor;
  final Color? scaffoldBackgroundColor;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const DefaultAppBar({
    super.key,
    this.extendBodyBehindAppBar,
    required this.resizeToAvoidBottomInset,
    this.title,
    this.titleColor,
    this.fontWeight,
    this.fontSize,
    this.foregroundColor,
    this.appBarBackgroundColor,
    this.scaffoldBackgroundColor,
    required this.body,
    this.bottomNavigationBar,
    this.leading,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
      backgroundColor:
          scaffoldBackgroundColor ?? context.theme.appColors.background,
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: fontSize ?? 18.0,
            color: titleColor ?? context.theme.appColors.onSecondary,
          ),
        ),
        iconTheme: IconThemeData(
          color: foregroundColor ?? context.theme.appColors.onPrimary,
        ),
        leading: leading,
        actions: actions,
        backgroundColor: appBarBackgroundColor ?? Colors.transparent,
        elevation: 0,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
