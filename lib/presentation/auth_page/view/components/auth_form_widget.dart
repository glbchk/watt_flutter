import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
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

  final bool? showPassword;
  final bool? showRetypedPassword;

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
    this.showPassword,
    this.showRetypedPassword,
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
              autofocus: false,
              label: 'Email',
              hint: 'Email...',
              error: emailError,
              textInputAction: TextInputAction.next,
              onChanged: onChangedEmail,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: controllerPassword,
              autofocus: false,
              label: 'Password',
              hint: 'Start typing here...',
              onSuffixIconTap: () {
                context.read<AuthBloc>().add(TogglePasswordVisibilityEvent());
              },
              showPassword: showPassword,
              isPassword: true,
              error: passwordError,
              textInputAction: isRegisterMode
                  ? TextInputAction.next
                  : TextInputAction.done,
              onChanged: onChangedPassword,
            ),
            if (isRegisterMode) ...[
              SizedBox(height: 20.0),
              CustomTextField(
                controller: controllerRetypePassword,
                autofocus: false,
                label: 'Retype Password',
                hint: 'Start typing here...',
                onSuffixIconTap: () {
                  context.read<AuthBloc>().add(
                    ToggleRetypePasswordVisibilityEvent(),
                  );
                },
                showPassword: showRetypedPassword,
                isPassword: true,
                error: retypePasswordError,
                textInputAction: TextInputAction.done,
                onChanged: onChangedRetypePassword,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
