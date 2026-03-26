import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/settings_pages/cars_page/sub_pages/components/plate_number_car_details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class ProfileCarDetailsPage extends StatelessWidget {
  final CarModel car;

  const ProfileCarDetailsPage({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> carDetailsLabels = ['Name', 'Brand', 'Model', 'Plate'];
    final List<String> carDetailsSecondLabels = [
      "${car.brandName}, ${car.carModel}",
      ?car.brandName,
      ?car.carModel,
      ?car.plateNumber,
    ];

    return DefaultAppBar(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      title: 'Charger station details',
      titleColor: context.theme.appColors.onPrimary,
      foregroundColor: context.theme.appColors.onPrimary,
      appBarBackgroundColor: context.theme.appColors.primary,
      scaffoldBackgroundColor: context.theme.appColors.background,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.theme.appColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          carDetailsLabels.length,
                          (index) {
                            return RowButton(
                              label: carDetailsLabels.elementAt(index),
                              secondLabel: carDetailsSecondLabels.elementAt(
                                index,
                              ),
                              hideChevron:
                                  carDetailsLabels.elementAt(index) == 'Plate'
                                  ? true
                                  : false,
                              onPressed: () =>
                                  carDetailsLabels.elementAt(index) == 'Plate'
                                  ? _navigateToPlateEdit(context)
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
                        right: 20.0,
                        bottom: 10.0,
                      ),
                      child: WattWhiteButton(
                        textColor: context.theme.appColors.error,
                        label: 'Delete car',
                        onPressed: () {
                          context.read<OnboardingBloc>().add(
                            DeleteCarEvent(carId: car.id),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPlateEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlateNumberCarDetailsPage(
          initialPlateNumber: car.plateNumber,
          onPressed: (plateNumber) {
            context.read<OnboardingBloc>().add(
              UpdatePlateNumberCarEvent(
                carId: car.id,
                plateNumber: plateNumber,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
