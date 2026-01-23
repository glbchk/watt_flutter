import 'package:flutter/material.dart';
import 'package:watt/presentation/widgets/custom_textfield.dart';
import 'package:watt/presentation/widgets/header_widget.dart';
import 'package:watt/presentation/widgets/main_button.dart';
import 'package:watt/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: wattColorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: HeaderWidget(
                title: 'Welcome back',
                backgroundColor: wattGradient,
              ),
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controllerEmail,
                      label: 'Login',
                      hint: 'Email...',
                    ),
                    SizedBox(height: 10.0),
                    CustomTextField(
                      controller: controllerPassword,
                      label: 'Password',
                      hint: 'Password...',
                      suffixIcon: Icons.visibility,
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: wattColorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    MainButton(
                      onPressed: () {},
                      label: 'Sign in',
                      isLoading: false,
                      // icon: ,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {},
                          child: Text('Sign up'),
                        ),
                      ],
                    ),
                    SizedBox(height: 120.0),
                    MainButton(
                      onPressed: () {},
                      label: 'Continue as guest',
                      isLoading: false,
                      backgroundColor: Colors.white,
                      textColor: wattColorScheme.onSecondary,
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
