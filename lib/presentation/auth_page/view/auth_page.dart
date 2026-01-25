import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/auth_page/view/components/custom_textfield.dart';
import 'package:watt/presentation/auth_page/view/components/header_widget.dart';
import 'package:watt/presentation/auth_page/view/components/main_button.dart';
import 'package:watt/utils/colors.dart';

import '../../home_page/view/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRetypePassword = TextEditingController();

  bool isRegisterMode = false;

  @override
  void dispose() {
    controllerPhoneNumber.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: wattColorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
              (route) => false,
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: HeaderWidget(
                    title: !isRegisterMode
                        ? 'Welcome back'
                        : 'Create an account',
                    backgroundColor: wattGradient,
                  ),
                ),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controllerPhoneNumber,
                          label: 'Phone Number',
                          hint: 'Phone number...',
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextField(
                          controller: controllerPassword,
                          label: 'Password',
                          hint: 'Start typing here...',
                          suffixIcon: Icons.visibility_off,
                        ),
                        if (isRegisterMode) ...[
                          SizedBox(height: 20.0),
                          CustomTextField(
                            controller: controllerRetypePassword,
                            label: 'Retype Password',
                            hint: 'Start typing here...',
                            suffixIcon: Icons.visibility_off,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'By creating an account you accept ',
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigate to terms screen here
                                    },
                                    child: const Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 20.0),
                        if (!isRegisterMode) ...[
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
                        ],
                        SizedBox(height: 20.0),
                        MainButton(
                          onPressed: () {
                            if (isRegisterMode) {
                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  user: UserEntity(
                                    email: controllerPhoneNumber.text,
                                  ),
                                  password: controllerPassword.text,
                                ),
                              );
                            } else {
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: controllerPhoneNumber.text,
                                  password: controllerPassword.text,
                                ),
                              );
                            }
                          },
                          label: !isRegisterMode ? 'Sign in' : 'Sign up',
                          isLoading: isLoading,
                          // icon: ,
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
                                  isRegisterMode = !isRegisterMode;
                                });
                              },
                              child: Text(
                                !isRegisterMode ? 'Sign up' : 'Sign in',
                              ),
                            ),
                          ],
                        ),
                        if (!isRegisterMode) ...[
                          SizedBox(height: 120.0),
                          MainButton(
                            onPressed: () {},
                            label: 'Continue as guest',
                            isLoading: isLoading,
                            backgroundColor: Colors.white,
                            textColor: wattColorScheme.onSecondary,
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
