import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number/components/add_name_phone_number_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

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
  void initState() {
    super.initState();

    final state = context.read<OnboardingBloc>().state;
    controllerName.text = state.name ?? '';
    controllerPhoneNumber.text = state.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: wattGradient,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add your name & email',
                        style: TextStyle(
                          color: context.theme.appColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'We need email to send you receipts and updates',
                        style: TextStyle(
                          color: context.theme.appColors.background,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                    ],
                  ),
                ),

                Transform.translate(
                  offset: Offset(0, -40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AddNamePhoneNumberWidget(
                        controllerName: controllerName,
                        controllerPhoneNumber: controllerPhoneNumber,
                        errorName: state.nameError,
                        errorPhoneNumber: state.phoneNumberError,
                        nameSuffixIcon: state.isNameValid ?? false
                            ? Icons.check
                            : null,
                        onChangedName: (value) {
                          print(value);
                          context.read<OnboardingBloc>().add(
                            NameVerificationEvent(
                              value: value ?? '',
                            ),
                          );
                        },
                        phoneNumberSuffixIcon: state.isPhoneNumberValid ?? false
                            ? Icons.check
                            : null,
                        onChangedPhoneNumber: (value) {
                          print(value);
                          context.read<OnboardingBloc>().add(
                            PhoneNumberVerificationEvent(value: value ?? ''),
                          );
                        },
                        isNameValid: state.isNameValid ?? false,
                        isPhoneNumberValid: state.isPhoneNumberValid ?? false,
                        onPressSave: () {
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
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              (state.isNameValid ?? false) &&
                  (state.isPhoneNumberValid ?? false)
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
