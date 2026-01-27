import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/utils/global_components/rich_text_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_text_button.dart';

class ButtonsSectionWidget extends StatelessWidget {
  final bool isRegisterMode;
  final VoidCallback loginCallback;
  final VoidCallback registerCallback;
  final VoidCallback forgotPasswordCallback;
  final VoidCallback termsAndConditionsCallback;
  final bool isLoading;

  const ButtonsSectionWidget({
    super.key,
    required this.isRegisterMode,
    required this.loginCallback,
    required this.registerCallback,
    required this.forgotPasswordCallback,
    required this.termsAndConditionsCallback,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          if (!isRegisterMode) ...[
            WattTextButton(
              callback: forgotPasswordCallback,
              label: 'Forgot password?',
              isRegister: isRegisterMode,
            ),
            SizedBox(height: 20.0),
          ] else ...[
            RichTextWidget(
              callback: termsAndConditionsCallback,
            ),
            SizedBox(height: 20.0),
          ],
          SizedBox(height: 20.0),
          WattMainButton(
            onPressed: () {
              !isRegisterMode ? loginCallback() : registerCallback();
            },
            label: !isRegisterMode ? 'Sign in' : 'Sign up',
            isLoading: isLoading,
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                !isRegisterMode
                    ? "Don't have an account?"
                    : 'Already have an account?',
              ),
              TextButton(
                onPressed: () {
                  print('call ChangeAuthModeEvent isRegisterMode: ${!isRegisterMode}');
                  context.read<AuthBloc>().add(
                    ChangeAuthModeEvent(isRegisterMode: !isRegisterMode),
                  );
                },
                child: Text(
                  isRegisterMode ? 'Sign in' : 'Sign up',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
