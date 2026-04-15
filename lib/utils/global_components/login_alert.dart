import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class LoginAlertWidget extends StatelessWidget {
  final String title;
  final String? message;
  final TextEditingController? passwordController;
  final String? passwordError;
  final String? buttonLabel;
  final VoidCallback? onConfirm;

  const LoginAlertWidget({
    super.key,
    required this.title,
    this.message,
    this.passwordController,
    this.passwordError,
    this.buttonLabel,
    this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    TextEditingController? passwordController,
    String? passwordError,
    String? buttonLabel,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return LoginAlertWidget(
              title: title,
              message: message,
              passwordController: passwordController,
              passwordError: state.passwordError,
              buttonLabel: buttonLabel,
              onConfirm: onConfirm,
            );
          },
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            message ?? '',
            style: TextStyle(
              fontSize: 15,
              color: context.theme.appColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          CustomTextField(
            label: 'Password',
            controller: passwordController,
            autofocus: true,
            isPassword: true,
            hint: 'Start typing here',
            error: passwordError,
          ),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        WattMainButton(
          label: buttonLabel ?? '',
          onPressed: () {
            onConfirm?.call();
          },
        ),
      ],
    );
  }
}
