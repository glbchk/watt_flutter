import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/onboarding_page/view/components/add_name_phone_number_form.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

import 'components/short_header_onboarding.dart';

class AddNameAndPhoneNumberPage extends StatefulWidget {
  const AddNameAndPhoneNumberPage({super.key});

  @override
  State<AddNameAndPhoneNumberPage> createState() =>
      _AddNameAndPhoneNumberPageState();
}

class _AddNameAndPhoneNumberPageState extends State<AddNameAndPhoneNumberPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    controllerName.dispose();
    controllerPhoneNumber.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? errorNameText;
    String? errorPhoneNumberText;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NameValidState) {
          errorNameText = state.value;
          NameValidState(state.value);
        }
        if (state is PhoneNumberValidState) {
          errorPhoneNumberText = state.value;
          PhoneNumberValidState(state.value);
        }
        if (state is AuthInProgressState) {
          Navigator.pop(context);
        }
      },

      builder: (context, state) {
        final isLoading = state is AuthInProgressState;
        final isNameValid = state is NameValidState ? true : false;
        final isPhoneNumberValid = state is PhoneNumberValidState
            ? true
            : false;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: ShortHeaderOnboarding(
                mainTitle: 'Add your name & email',
                subtitle: 'We need email to send you receipts and updates',
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                BackgroundGradient(
                  bgHeight: 0.28,
                ),
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AddNamePhoneNumberFormWidget(
                        controllerName: controllerName,
                        controllerPhoneNumber: controllerPhoneNumber,
                        errorName: errorNameText,
                        errorPhoneNumber: errorPhoneNumberText,
                        nameSuffixIcon: isNameValid ? Icons.check : null,
                        onChangedName: (value) {
                          print(value);
                          context.read<AuthBloc>().add(
                            NameVerificationEvent(
                              value: value ?? '',
                            ),
                          );
                        },
                        phoneNumberSuffixIcon: isPhoneNumberValid
                            ? Icons.check
                            : null,
                        onChangedPhoneNumber: (value) {
                          print(value);
                          context.read<AuthBloc>().add(
                            PhoneNumberVerificationEvent(value: value ?? ''),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                isNameValid
                    ? SizedBox()
                    : WattMainButton(
                        label: 'Save',
                        isLoading: isLoading,
                        onPressed: () {},
                      ),
              ],
            ),
          ),
          bottomNavigationBar: isNameValid
              ? const SizedBox()
              : BottomFloatingButton(
                  label: 'Complete later',
                  callback: () {},
                ),
        );
      },
    );
  }
}
