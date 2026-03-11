import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class AuthFormWidget extends StatelessWidget {
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final TextEditingController controllerRetypePassword;
  final bool isRegisterMode;

  final Function(String?) onChangedEmail;
  final Function(String?) onChangedPassword;
  final Function(String?) onChangedRetypePassword;

  final String? emailError;
  final String? passwordError;
  final String? retypePasswordError;

  const AuthFormWidget({
    super.key,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.controllerRetypePassword,
    required this.isRegisterMode,
    required this.onChangedEmail,
    required this.onChangedPassword,
    required this.onChangedRetypePassword,
    this.emailError,
    this.passwordError,
    this.retypePasswordError,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomTextField(
              controller: controllerEmail,
              label: 'Email',
              hint: 'Email...',
              error: emailError,
              onChanged: onChangedEmail,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: controllerPassword,
              label: 'Password',
              hint: 'Start typing here...',
              suffixIcon: Icon(Icons.visibility_off),
              isPassword: true,
              error: passwordError,
              onChanged: onChangedPassword,
            ),
            if (isRegisterMode) ...[
              SizedBox(height: 20.0),
              CustomTextField(
                controller: controllerRetypePassword,
                label: 'Retype Password',
                hint: 'Start typing here...',
                suffixIcon: Icon(Icons.visibility_off),
                isPassword: true,
                error: retypePasswordError,
                onChanged: onChangedRetypePassword,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
