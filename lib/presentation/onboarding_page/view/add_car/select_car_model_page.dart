import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/components/select_car_model_form_widget.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/presentation/onboarding_page/view/components/short_header_onboarding.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class SelectCarModelPage extends StatefulWidget {
  final String brandName;
  final String? dropdownValue;

  const SelectCarModelPage({
    super.key,
    required this.brandName,
    this.dropdownValue,
  });

  @override
  State<SelectCarModelPage> createState() => _SelectCarModelPageState();
}

class _SelectCarModelPageState extends State<SelectCarModelPage> {
  TextEditingController plateController = TextEditingController();
  var items = ['One', 'Two', 'Three', 'Four'];
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.dropdownValue;
  }

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String? errorNameText;
    // String? errorPhoneNumberText;

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        // if (state is NameValidState) {
        //   errorNameText = state.value;
        //   NameValidState(state.value, state.isNameValid);
        // }
        // if (state is PhoneNumberValidState) {
        //   errorPhoneNumberText = state.value;
        //   PhoneNumberValidState(state.value, state.isPhoneNumberValid);
        // }
        // if (state is ToggleNamePhoneNumberState) {
        //   Navigator.pop(context);
        //   ToggleNamePhoneNumberState(state.isNamePhoneNumberChanged);
        // }
      },

      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: ShortHeaderOnboarding(
                mainTitle: widget.brandName,
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
                      child: SelectCarModelFormWidget(
                        selectedValue: _dropdownValue,
                        listItems: items,
                        onDropdownChanged: (String? newValue) {
                          setState(() {
                            _dropdownValue = newValue ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: WattMainButton(
                    label: 'Save',
                    onPressed: () {
                      // context.read<OnboardingBloc>().add(
                      // OnboardingSaveEvent(
                      //   name: controllerName.text,
                      //   phoneNumber: controllerPhoneNumber.text,
                      // ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
