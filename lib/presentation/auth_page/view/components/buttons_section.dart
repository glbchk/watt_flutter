import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/rich_text_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_text_button.dart';
import 'package:watt/utils/notifiers.dart';

class ButtonsSectionWidget extends StatefulWidget {
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
  State<ButtonsSectionWidget> createState() => _ButtonsSectionWidgetState();
}

class _ButtonsSectionWidgetState extends State<ButtonsSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isRegisterNotifier,
      builder: (context, isRegisterMode, child) {
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
                  callback: widget.forgotPasswordCallback,
                  label: 'Forgot password?',
                  isRegister: isRegisterMode,
                ),
                SizedBox(height: 20.0),
              ] else ...[
                RichTextWidget(
                  callback: widget.termsAndConditionsCallback,
                ),
                SizedBox(height: 20.0),
              ],
              SizedBox(height: 20.0),
              WattMainButton(
                onPressed: () {
                  !isRegisterMode
                      ? widget.loginCallback()
                      : widget.registerCallback();
                },
                label: !isRegisterMode ? 'Sign in' : 'Sign up',
                isLoading: widget.isLoading,
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
                      setState(() {
                        isRegisterNotifier.value = !isRegisterNotifier.value;
                        print('Changed');
                      });
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
      },
    );
  }
}
