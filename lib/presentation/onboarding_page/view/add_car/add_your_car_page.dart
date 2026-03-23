import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/select_car_model_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class AddYourCarPage extends StatefulWidget {
  const AddYourCarPage({super.key});

  @override
  State<AddYourCarPage> createState() => _AddYourCarPageState();
}

class _AddYourCarPageState extends State<AddYourCarPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(FetchUserCarsEvent());
    context.read<OnboardingBloc>().add(FetchMockedCarOptionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final double marginSize = 10.0;

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: Stack(
            children: [
              CustomScrollView(
                physics: ClampingScrollPhysics(),
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
                                'Add your car',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Select your car',
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
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                          ),
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 1.3,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.cars != null &&
                                    state.cars!.isNotEmpty) ...[
                                  Column(
                                    spacing: 10,
                                    children: [
                                      ...state.cars!.map((car) {
                                        return TallCardButton(
                                          isDismissible: true,
                                          dismissableKey: car.id,
                                          onDismissableDismissed: () {
                                            context.read<OnboardingBloc>().add(
                                              DeleteCarEvent(
                                                carId: car.id,
                                              ),
                                            );
                                          },
                                          label: car.carModel ?? '',
                                          subLabel: car.plateNumber,
                                          pngImage: car.brandLogo,
                                          marginDistance: marginSize,
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (_) =>
                                            //         ProfileCarDetailsPage(
                                            //           car: car,
                                            //         ),
                                            //   ),
                                            // );
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                  const SizedBox(height: 30.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text(
                                      'Add Another Car'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.theme.appColors.grey1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                                Column(
                                  spacing: 10,
                                  children: [
                                    state.isLoading
                                        ? UiHelperMethods.buildCarOptionsShimmer(
                                            context,
                                          )
                                        : Column(
                                            spacing: 10,
                                            children: [
                                              ...(state.carOptions ?? []).map((
                                                option,
                                              ) {
                                                return TallCardButton(
                                                  isDismissible: false,
                                                  label: option.name,
                                                  pngImage: option.logo,
                                                  marginDistance: marginSize,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            SelectCarModelPage(
                                                              brandLogo:
                                                                  option.logo,
                                                              brandName:
                                                                  option.name,
                                                              brand:
                                                                  option.brand,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 100,
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
              if (!(state.cars?.isEmpty ?? true))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.appColors.onSecondary.withAlpha(
                            26,
                          ),
                          spreadRadius: 0,
                          blurRadius: 30,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: SafeArea(
                      child: WattMainButton(
                        label: 'Save',
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
