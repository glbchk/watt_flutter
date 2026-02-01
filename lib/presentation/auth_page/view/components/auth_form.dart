import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';

class AuthFormWidget extends StatelessWidget {
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final TextEditingController controllerRetypePassword;
  final bool isRegisterMode;

  const AuthFormWidget({
    super.key,
    required this.controllerEmail,
    required this.controllerPassword,
    required this.controllerRetypePassword,
    required this.isRegisterMode,
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
              onChanged: (String? p1) {},
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: controllerPassword,
              label: 'Password',
              hint: 'Start typing here...',
              suffixIcon: Icons.visibility_off,
              onChanged: (String? p1) {},
            ),
            if (isRegisterMode) ...[
              SizedBox(height: 20.0),
              CustomTextField(
                controller: controllerRetypePassword,
                label: 'Retype Password',
                hint: 'Start typing here...',
                suffixIcon: Icons.visibility_off,
                onChanged: (String? p1) {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
