import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

class DefaultAppBar extends StatelessWidget {
  final bool showAppBar;

  final bool? extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  final AppBar? appBar;
  final Widget? drawer;
  final Color? drawerScrimColor;
  final String? title;
  final bool? centerTitle;
  final Color? titleColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? foregroundColor;
  final Color? appBarBackgroundColor;
  final Color? scaffoldBackgroundColor;
  final Color? shadowColor;
  final double? blurRadius;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final double? kToolbarHeight;

  const DefaultAppBar({
    super.key,
    this.showAppBar = true,
    this.extendBodyBehindAppBar,
    required this.resizeToAvoidBottomInset,
    this.appBar,
    this.drawer,
    this.drawerScrimColor,
    this.title,
    this.centerTitle,
    this.titleColor,
    this.fontWeight,
    this.fontSize,
    this.foregroundColor,
    this.appBarBackgroundColor,
    this.scaffoldBackgroundColor,
    this.shadowColor,
    this.blurRadius,
    required this.body,
    this.bottomNavigationBar,
    this.leading,
    this.actions,
    this.floatingActionButton,
    this.kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
      backgroundColor:
          scaffoldBackgroundColor ?? context.theme.appColors.background,
      drawer: drawer,
      drawerScrimColor: drawerScrimColor,
      appBar: showAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight ?? 56.0),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      appBarBackgroundColor ??
                      context.theme.appColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor ?? context.theme.appColors.transparent,
                      blurRadius: blurRadius ?? 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child:
                    (appBar ??
                    AppBar(
                      title: Text(
                        title ?? '',
                        style: TextStyle(
                          fontWeight: fontWeight ?? FontWeight.bold,
                          fontSize: fontSize ?? 18.0,
                          color:
                              titleColor ?? context.theme.appColors.onSecondary,
                        ),
                      ),
                      centerTitle: centerTitle ?? true,
                      iconTheme: IconThemeData(
                        color:
                            foregroundColor ??
                            context.theme.appColors.onPrimary,
                      ),
                      leading: leading,
                      actions: actions,
                      backgroundColor: context.theme.appColors.transparent,
                      surfaceTintColor: context.theme.appColors.transparent,
                      elevation: 0,
                    )),
              ),
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
