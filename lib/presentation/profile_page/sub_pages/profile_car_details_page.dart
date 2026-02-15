import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/profile_page/sub_pages/property_pages/plate_number_car_details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class ProfileCarDetailsPage extends StatefulWidget {
  final String carId;

  const ProfileCarDetailsPage({
    super.key,
    required this.carId,
  });

  @override
  State<ProfileCarDetailsPage> createState() => _ProfileCarDetailsPageState();
}

class _ProfileCarDetailsPageState extends State<ProfileCarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final cars = state.cars ?? [];
        final car = cars.where((car) => car.id == widget.carId).isNotEmpty
            ? cars.firstWhere((car) => car.id == widget.carId)
            : null;

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(
              'Charger station details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: wattColorScheme.primary,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowButton(
                                    label: 'Name',
                                    secondLabel:
                                        "${car?.brandName}, ${car?.carModel}",
                                    onPressed: () {},
                                    hideChevron: false,
                                  ),
                                  RowButton(
                                    label: 'Brand',
                                    secondLabel: car?.brandName,
                                    onPressed: () {},
                                    hideChevron: false,
                                  ),
                                  RowButton(
                                    label: 'Model',
                                    secondLabel: car?.carModel,
                                    onPressed: () {},
                                    hideChevron: false,
                                  ),
                                  RowButton(
                                    label: 'Plate',
                                    secondLabel: car?.plateNumber,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PlateNumberCarDetailsPage(
                                                controllerPlateNumber:
                                                    TextEditingController(
                                                      text: car?.plateNumber,
                                                    ),
                                                carID: widget.carId,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 20.0,
              right: 20.0,
              bottom: 34.0,
            ),
            child: WattMainButton(
              backgroundColor: Colors.white,
              textColor: wattColorScheme.error,
              label: 'Delete car',
              onPressed: () {
                context.read<OnboardingBloc>().add(
                  DeleteCarEvent(carId: car?.id ?? ''),
                );
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}
