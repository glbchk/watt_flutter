import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_name_phone_number/components/add_name_phone_number_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

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
        print(state.nameError);
        print(state.phoneNumberError);
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          leading: BackButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(
                NameVerificationEvent(value: ''),
              );
              context.read<OnboardingBloc>().add(
                PhoneNumberVerificationEvent(value: ''),
              );
              Navigator.of(context).pop();
            },
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
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
                        Container(
                          color: context.theme.appColors.background,
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 1.3,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            context.theme.appColors.background,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 200.0,
                                        ),
                                        child: AddNamePhoneNumberWidget(
                                          controllerName: controllerName,
                                          controllerPhoneNumber:
                                              controllerPhoneNumber,
                                          errorName: state.nameError,
                                          errorPhoneNumber:
                                              state.phoneNumberError,
                                          nameSuffixIcon:
                                              state.isNameValid ?? false
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
                                          phoneNumberSuffixIcon:
                                              state.isPhoneNumberValid ?? false
                                              ? Icons.check
                                              : null,
                                          onChangedPhoneNumber: (value) {
                                            print(value);
                                            context.read<OnboardingBloc>().add(
                                              PhoneNumberVerificationEvent(
                                                value: value ?? '',
                                              ),
                                            );
                                          },
                                          isNameValid:
                                              state.isNameValid ?? false,
                                          isPhoneNumberValid:
                                              state.isPhoneNumberValid ?? false,
                                          onPressSave: () {
                                            context.read<OnboardingBloc>().add(
                                              OnboardingFilledNamePhoneNumberEvent(
                                                name: controllerName.text,
                                                phoneNumber:
                                                    controllerPhoneNumber.text,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!(state.isNameValid ?? false) &&
                  !(state.isPhoneNumberValid ?? false))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.transparent,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: context.theme.appColors.onSecondary.withAlpha(
                      //       26,
                      //     ),
                      //     spreadRadius: 0,
                      //     blurRadius: 30,
                      //     offset: Offset(0, 0),
                      //   ),
                      // ],
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: SafeArea(
                      child: WattWhiteButton(
                        label: 'Complete later',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
