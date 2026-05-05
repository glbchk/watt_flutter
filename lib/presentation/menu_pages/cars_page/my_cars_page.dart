import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/cars_page/bloc/my_cars_cubit.dart';
import 'package:watt/presentation/menu_pages/cars_page/bloc/my_cars_state.dart';
import 'package:watt/presentation/menu_pages/cars_page/sub_pages/add_new_car_page.dart';
import 'package:watt/presentation/menu_pages/cars_page/sub_pages/car_details_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/empty_tall_card_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyCarsCubit>().fetchUserCarsData();
    context.read<MyCarsCubit>().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCarsCubit, MyCarsState>(
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
                                'My cars',
                                style: TextStyle(
                                  color: context.theme.appColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                'Here you can list all your cars',
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
                            minHeight:
                                MediaQuery.of(context).size.height / 1.27,
                          ),
                          child: Transform.translate(
                            offset: Offset(0, -40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.userCars != null &&
                                    state.userCars!.isNotEmpty) ...[
                                  Column(
                                    spacing: 10,
                                    children: [
                                      ...state.userCars!.map((car) {
                                        return TallCardButton(
                                          isDismissible: true,
                                          dismissableKey: car.id,
                                          onDismissableDismissed: () {
                                            context
                                                .read<MyCarsCubit>()
                                                .deleteCar(car.id);
                                          },
                                          label: car.carModel ?? '',
                                          subLabel: car.plateNumber,
                                          pngImage: car.brandLogo,
                                          marginDistance: marginSize,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CarDetailsPage(
                                                  car: car,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ] else ...[
                                  EmptyTallCardButton(
                                    label: 'No cars added',
                                    subLabel: 'Please add your cars below',
                                    marginDistance: marginSize,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 34,
                child: WattWhiteButton(
                  label: 'Add car',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddNewCarPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
