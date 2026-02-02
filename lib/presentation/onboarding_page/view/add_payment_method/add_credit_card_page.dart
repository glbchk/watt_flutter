import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/components/credit_card_form_widget.dart';
import 'package:watt/utils/colors.dart';

class AddCreditCardPage extends StatefulWidget {
  final String? dropdownValue;

  const AddCreditCardPage({
    super.key,
    this.dropdownValue,
  });

  @override
  State<AddCreditCardPage> createState() => _AddCreditCardPageState();
}

class _AddCreditCardPageState extends State<AddCreditCardPage> {
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
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Credit card details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // backgroundColor: wattColorScheme.primary,
            // elevation: 0,
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(20.0),
            //   child: ShortHeaderOnboarding(
            //     mainTitle: '',
            //   ),
            // ),
          ),
          backgroundColor: wattColorScheme.primary,
          body: Container(
            // constraints: BoxConstraints(
            //   minHeight: MediaQuery.of(context).size.height,
            // ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CreditCardFormWidget(),
            ),
          ),
        );
      },
    );
  }
}
