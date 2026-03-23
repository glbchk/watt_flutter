import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class WattAlert extends StatelessWidget {
  final String? svg;
  final String title;
  final String? message;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final String? errorMessage;
  final String? buttonLabel;
  final VoidCallback? onConfirm;

  const WattAlert({
    super.key,
    this.svg,
    required this.title,
    this.message,
    this.controller,
    this.onChanged,
    this.errorMessage,
    this.buttonLabel,
    this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    String? svg,
    required String title,
    String? message,
    TextEditingController? controller,
    Function(String?)? onChanged,
    String? emailError,
    String? buttonLabel,
    VoidCallback? onConfirm,
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

              return WattAlert(
                svg: svg,
                title: title,
                message: message,
                controller: controller,
                onChanged: onChanged,
                errorMessage: currentError,
                buttonLabel: buttonLabel,
                onConfirm: onConfirm,
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
          if (message != null) const SizedBox(height: 30),
          if (controller != null)
            CustomTextField(
              label: 'Email',
              controller: controller,
              autofocus: true,
              hint: 'Start typing here',
              onChanged: onChanged,
              error: errorMessage,
            ),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        WattMainButton(
          label: buttonLabel ?? '',
          onPressed: () {
            if (onConfirm != null) onConfirm?.call();
          },
        ),
      ],
    );
  }
}
