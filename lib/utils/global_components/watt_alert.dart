import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class WattAlertWidget extends StatelessWidget {
  final String? svg;
  final String title;
  final String? message;
  final double? heightBetweenMessageAndTextfield;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final String? errorMessage;
  final String? buttonLabel;
  final VoidCallback? onConfirm;
  final Color? buttonColor;
  final String? cancelLabel;
  final VoidCallback? onCancelConfirm;

  const WattAlertWidget({
    super.key,
    this.svg,
    required this.title,
    this.message,
    this.heightBetweenMessageAndTextfield,
    this.controller,
    this.onChanged,
    this.errorMessage,
    this.buttonLabel,
    this.onConfirm,
    this.buttonColor,
    this.cancelLabel,
    this.onCancelConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    String? svg,
    required String title,
    String? message,
    double? heightBetweenMessageAndTextfield,
    TextEditingController? controller,
    Function(String?)? onChanged,
    String? emailError,
    String? buttonLabel,
    VoidCallback? onConfirm,
    Color? buttonColor,
    String? cancelLabel,
    VoidCallback? onCancelConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              Navigator.pop(dialogContext);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String? currentError;
              if (state is AuthUnauthenticatedState) {
                currentError = state.forgotPasswordError;
              }

              return WattAlertWidget(
                svg: svg,
                title: title,
                message: message,
                heightBetweenMessageAndTextfield:
                    heightBetweenMessageAndTextfield,
                controller: controller,
                onChanged: onChanged,
                errorMessage: currentError,
                buttonLabel: buttonLabel,
                onConfirm: onConfirm,
                cancelLabel: cancelLabel,
                onCancelConfirm: onCancelConfirm,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.theme.appColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (svg != null) const SizedBox(height: 80),
          if (svg != null) SvgPicture.asset(svg ?? ''),
          if (svg != null) const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          if (message != null)
            Text(
              message ?? '',
              style: TextStyle(
                fontSize: 15,
                color: context.theme.appColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          if (message != null)
            SizedBox(height: heightBetweenMessageAndTextfield ?? 30),
          if (controller != null)
            CustomTextField(
              label: 'Email',
              controller: controller,
              autofocus: true,
              hint: 'Start typing here',
              onChanged: onChanged,
              error: errorMessage,
            ),
          if (controller != null) const SizedBox(height: 20),
        ],
      ),
      actions: [
        Row(
          children: [
            if (cancelLabel != null)
              Expanded(
                child: WattWhiteButton(
                  label: cancelLabel ?? '',
                  onPressed: () => onCancelConfirm?.call(),
                ),
              ),

            if (cancelLabel != null) const SizedBox(width: 12),
            Expanded(
              child: WattMainButton(
                label: buttonLabel ?? '',
                textColor: context.theme.appColors.error,
                backgroundColor:
                    buttonColor ?? context.theme.appColors.background,
                buttonShadow: cancelLabel != null
                    ? context.theme.appColors.onSecondary.withAlpha(38)
                    : context.theme.appColors.primary.withAlpha(76),
                onPressed: () => onConfirm?.call(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
