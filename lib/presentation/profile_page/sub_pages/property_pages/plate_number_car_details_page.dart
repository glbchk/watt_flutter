import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class PlateNumberCarDetailsPage extends StatefulWidget {
  final String carID;
  final TextEditingController controllerPlateNumber;

  const PlateNumberCarDetailsPage({
    super.key,
    required this.carID,
    required this.controllerPlateNumber,
  });

  @override
  State<PlateNumberCarDetailsPage> createState() =>
      _PlateNumberCarDetailsPageState();
}

class _PlateNumberCarDetailsPageState extends State<PlateNumberCarDetailsPage> {
  @override
  void dispose() {
    widget.controllerPlateNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              'Plate number changed?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: wattColorScheme.surface,
          ),
          body: Form(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: widget.controllerPlateNumber,
                    label: 'Plate number',
                    hint: "XS2345",
                  ),
                  WattMainButton(
                    label: 'Save',
                    onPressed: () {
                      context.read<OnboardingBloc>().add(
                        UpdatePlateNumberCarEvent(
                          carId: widget.carID,
                          plateNumber: widget.controllerPlateNumber.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
