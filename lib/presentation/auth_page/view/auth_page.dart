import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/auth_page/view/components/buttons_section.dart';
import 'package:watt/presentation/auth_page/view/components/header_auth.dart';
import 'package:watt/presentation/onboarding_page/view/onboarding_page.dart';
import 'package:watt/utils/colors.dart';

import '../../../utils/global_components/bottom_floating_button.dart';
import '../../home_page/view/home_page.dart';
import 'components/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRetypePassword = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
          );
        }
        if (state is FirstTimeAuthState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OnboardingPage()),
          );
        }
        if (state is SignInAnonymouslyState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
          );
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        final isRegisterMode = state is AuthUnauthenticatedState
            ? state.isRegisterMode
            : false;

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: context.theme.appColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HeaderAuth(
                  title: !isRegisterMode ? 'Welcome back' : 'Create an account',
                ),
                AuthFormWidget(
                  controllerEmail: controllerEmail,
                  controllerPassword: controllerPassword,
                  controllerRetypePassword: controllerRetypePassword,
                  isRegisterMode: isRegisterMode,
                  // onChangedEmail: (String? value) {
                  //   setState(() {
                  //     if (value == null || !value.contains('@')) {
                  //       emailError = 'Please enter a valid email address.';
                  //     } else {
                  //       emailError = null; // Clear error if valid
                  //     }
                  //   });
                  onChangedEmail: (value) {
                    value;
                  },
                  onChangedPassword: (value) {
                    value;
                  },
                  onChangedRetypePassword: (value) {
                    value;
                  },
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
                        isOnboardingCompleted: false,
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
          ),
          bottomNavigationBar: isRegisterMode
              ? const SizedBox()
              : BottomFloatingButton(
                  label: 'Continue as guest',
                  callback: () {
                    context.read<AuthBloc>().add(
                      SignInAnonymouslyEvent(),
                    );
                  },
                ),
        );
      },
    );
  }
}
