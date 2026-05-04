import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/booking_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/home_page/view/sub_pages/pay_with_credit_card_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/line_card_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';

class PayDetailsPage extends StatefulWidget {
  final BookingModel booking;
  const PayDetailsPage({super.key, required this.booking});

  @override
  State<PayDetailsPage> createState() => _PayDetailsPageState();
}

class _PayDetailsPageState extends State<PayDetailsPage> {
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: DefaultAppBar(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: false,
            title: 'Pay charging station',
            titleColor: context.theme.appColors.onPrimary,
            appBarBackgroundColor: context.theme.appColors.primary,
            scaffoldBackgroundColor: context.theme.appColors.primary,
            blurRadius: 30,
            leading: BackButton(
              onPressed: () {
                // context.read<OnboardingBloc>().add(
                //   NameVerificationEvent(value: ''),
                // );
                // context.read<OnboardingBloc>().add(
                //   PhoneNumberVerificationEvent(value: ''),
                // );
                Navigator.of(context).pop();
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Text(
                                    state
                                            .chargingStation
                                            ?.chargingStationName ??
                                        '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        size: 24,
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/images/map_screenshot.png',
                                height: 80,
                                width: 80,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 8.0,
                            ),
                            child: Divider(
                              height: 1,
                              color: context.theme.appColors.grey3,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(
                                "John’s Amp",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: context.theme.appColors.grey3,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: context.theme.appColors.grey4,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Your charging session is finished',
                                style: TextStyle(
                                  color: context.theme.appColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 20),
                              LineCardWidget(
                                label: 'Choose Time Slot',
                                startTime:
                                    StringHelperMethods.convertToStartTime(
                                      widget.booking.date ?? '',
                                      widget.booking.selectedTimes ?? [],
                                    ),
                                endTime: StringHelperMethods.convertToEndTime(
                                  widget.booking.date ?? '',
                                  widget.booking.selectedTimes ?? [],
                                ),
                                energy: widget.booking.energyAmount != 0.0
                                    ? '${widget.booking.energyAmount.toString()} kWh'
                                    : 'No energy amount',
                                price: widget.booking.price != 0.0
                                    ? '${widget.booking.price.toString()} SEK'
                                    : 'No price',
                              ),
                              SizedBox(height: 170),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      !isChecked
                                          ? Icons.check_box_outline_blank
                                          : Icons.check_box,
                                      color: !isChecked
                                          ? context.theme.appColors.grey1
                                          : context.theme.appColors.primary,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Send receipt by e-mail',
                                      style: TextStyle(
                                        color: context.theme.appColors.grey1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              WattMainButton(
                                label: 'Pay',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PayWithCreditCardPage(
                                        booking: widget.booking,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 52),
                            ],
                          ),
                        ],
                      ),
                    ),
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
