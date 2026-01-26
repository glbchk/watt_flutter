import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/auth_page/view/components/buttons_section.dart';
import 'package:watt/presentation/auth_page/view/components/header_auth.dart';
import 'package:watt/presentation/onboarding_page/view/onboarding_page.dart';
import 'package:watt/utils/notifiers.dart';

import '../../../utils/global_components/bottom_floating_button.dart';
import '../../home_page/view/home_page.dart';
import 'components/form_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRetypePassword = TextEditingController();

  // bool isRegisterMode = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
              (route) => false,
            );
            isRegisterNotifier.value = false;
          }
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;
          return ValueListenableBuilder(
            valueListenable: isRegisterNotifier,
            builder: (context, isRegisterMode, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderAuth(
                      title: !isRegisterMode
                          ? 'Welcome back'
                          : 'Create an account',
                    ),
                    FormWidget(
                      controllerEmail: controllerEmail,
                      controllerPassword: controllerPassword,
                      controllerRetypePassword: controllerRetypePassword,
                      isRegisterMode: isRegisterMode,
                    ),
                    ButtonsSectionWidget(
                      loginCallback: () {
                        context.read<AuthBloc>().add(
                          LoginRequestedEvent(
                            email: controllerEmail.text,
                            password: controllerPassword.text,
                          ),
                        );
                      },
                      registerCallback: () {
                        context.read<AuthBloc>().add(
                          RegisterRequestedEvent(
                            email: controllerEmail.text,
                            password: controllerPassword.text,
                          ),
                        );
                      },
                      forgotPasswordCallback: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OnboardingPage(),
                          ),
                        );
                      },
                      termsAndConditionsCallback: () {},
                      isLoading: isLoading,
                      isRegisterMode: isRegisterMode,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: isRegisterNotifier,
        builder: (context, isRegisterMode, child) {
          if (isRegisterMode) return const SizedBox();
          return BottomFloatingButton(
            label: 'Continue as guest',
            callback: () {},
          );
        },
      ),
    );
  }
}
