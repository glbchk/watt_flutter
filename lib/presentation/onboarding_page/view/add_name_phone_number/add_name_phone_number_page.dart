import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number/components/add_name_phone_number_form_widget.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

import '../components/short_header_onboarding.dart';

class AddNameAndPhoneNumberPage extends StatefulWidget {
  const AddNameAndPhoneNumberPage({super.key});

  @override
  State<AddNameAndPhoneNumberPage> createState() =>
      _AddNameAndPhoneNumberPageState();
}

class _AddNameAndPhoneNumberPageState extends State<AddNameAndPhoneNumberPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();

  @override
  void dispose() {
    controllerName.dispose();
    controllerPhoneNumber.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final state = context.read<OnboardingBloc>().state;

    controllerName.text = state.name ?? '';
    controllerPhoneNumber.text = state.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
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
                        errorName: state.nameError,
                        errorPhoneNumber: state.phoneNumberError,
                        nameSuffixIcon: state.isNameValid ? Icons.check : null,
                        onChangedName: (value) {
                          print(value);
                          context.read<OnboardingBloc>().add(
                            NameVerificationEvent(
                              value: value ?? '',
                            ),
                          );
                        },
                        phoneNumberSuffixIcon: state.isPhoneNumberValid
                            ? Icons.check
                            : null,
                        onChangedPhoneNumber: (value) {
                          print(value);
                          context.read<OnboardingBloc>().add(
                            PhoneNumberVerificationEvent(value: value ?? ''),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (state.isNameValid || state.isPhoneNumberValid),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: WattMainButton(
                      label: 'Save',
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                          OnboardingFilledNamePhoneNumberEvent(
                            name: controllerName.text,
                            phoneNumber: controllerPhoneNumber.text,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: (state.isNameValid || state.isPhoneNumberValid)
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
