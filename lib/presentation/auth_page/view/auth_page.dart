import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/auth_page/view/components/buttons_section_widget.dart';
import 'package:watt/presentation/auth_page/view/components/header_auth_widget.dart';
import 'package:watt/presentation/onboarding_page/view/onboarding_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/watt_alert.dart';

import '../../../utils/global_components/bottom_floating_button.dart';
import '../../home_page/view/home_page.dart';
import 'components/auth_form_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRetypePassword = TextEditingController();
  TextEditingController forgotPasswordController = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerRetypePassword.dispose();
    forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
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
            MaterialPageRoute(
              builder: (_) => HomePage(),
            ),
            (route) => false,
          );
        }
        if (state is AuthUnauthenticatedState && state.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          });

          context.read<AuthBloc>().add(AuthSnackBarErrorMessageEvent(''));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthUnauthenticatedState
            ? state.isLoading
            : false;
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
                HeaderAuthWidget(
                  title: !isRegisterMode ? 'Welcome back' : 'Create an account',
                ),
                AuthFormWidget(
                  controllerEmail: controllerEmail,
                  controllerPassword: controllerPassword,
                  controllerRetypePassword: controllerRetypePassword,
                  isRegisterMode: isRegisterMode,
                  onChangedEmail: (String? value) {
                    context.read<AuthBloc>().add(
                      EmailVerificationEvent(
                        value: value ?? '',
                      ),
                    );
                  },
                  emailError: (state is AuthUnauthenticatedState)
                      ? state.emailError
                      : null,
                  onChangedPassword: (String? value) {
                    context.read<AuthBloc>().add(
                      PasswordVerificationEvent(
                        value: value ?? '',
                      ),
                    );
                  },
                  showPassword: (state is AuthUnauthenticatedState)
                      ? state.isPasswordVisible
                      : null,
                  showRetypedPassword: (state is AuthUnauthenticatedState)
                      ? state.isRetypePasswordVisible
                      : null,
                  passwordError: (state is AuthUnauthenticatedState)
                      ? state.passwordError
                      : null,
                  onChangedRetypePassword: (String? value) {
                    context.read<AuthBloc>().add(
                      RetypePasswordVerificationEvent(
                        value: value ?? '',
                      ),
                    );
                  },
                  retypePasswordError: (state is AuthUnauthenticatedState)
                      ? state.retypePasswordError
                      : null,
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
                        retypePassword: controllerRetypePassword.text,
                        isOnboardingCompleted: false,
                      ),
                    );
                  },
                  forgotPasswordCallback: () {
                    WattAlertWidget.show(
                      context: context,
                      title: 'Forgot your password?',
                      message:
                          'Enter your phone number or email address to reset your password',
                      buttonLabel: 'Reset',
                      controller: forgotPasswordController,
                      onChanged: (String? value) {
                        context.read<AuthBloc>().add(
                          ForgotPasswordEmailVerificationEvent(
                            value: value ?? '',
                          ),
                        );
                      },
                      onConfirm: () {
                        final bloc = context.read<AuthBloc>();
                        final email = forgotPasswordController.text;

                        bloc.add(
                          ForgotPasswordEmailVerificationEvent(value: email),
                        );

                        final state = bloc.state;
                        if (state is AuthUnauthenticatedState &&
                            state.forgotPasswordError == null) {
                          bloc.add(SendPasswordResetEmailEvent(email: email));
                        }

                        WattAlertWidget.show(
                          context: context,
                          svg: 'assets/icons/ic_success.svg',
                          title: 'Password reset successfully',
                          message:
                              'We’ve sent you an email. Please check your inbox and reset your password.',
                          buttonLabel: 'Okay',
                          onConfirm: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        );
                      },
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
