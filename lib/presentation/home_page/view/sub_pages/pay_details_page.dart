import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/line_card_widget.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class PayDetailsPage extends StatefulWidget {
  final ChargingStationType type;
  const PayDetailsPage({super.key, required this.type});

  @override
  State<PayDetailsPage> createState() => _PayDetailsPageState();
}

class _PayDetailsPageState extends State<PayDetailsPage> {
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: DefaultAppBar(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: false,
            title: isCollapsed ? 'Past booking' : null,
            titleColor: context.theme.appColors.onSecondary,
            appBarBackgroundColor: context.theme.appColors.background,
            scaffoldBackgroundColor: context.theme.appColors.background,
            shadowColor: isCollapsed
                ? context.theme.appColors.onSecondary.withValues(
                    alpha: 0.1,
                  )
                : null,
            blurRadius: 30,
            leading: BackButton(
              color: context.theme.appColors.onSecondary,
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
            body: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      final offset = scrollNotification.metrics.pixels;
                      final collapsed = offset > 20;

                      if (collapsed != isCollapsed) {
                        setState(() {
                          isCollapsed = collapsed;
                        });
                      }
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
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
                                  top: 10.0,
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 2,
                                          children: [
                                            Text(
                                              'Charging Station Here',
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
                                                  size: 20,
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                Text(
                                                  '4.8',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              '2020-11-09',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 80,
                                          width: 80,
                                          color: Colors.black,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    widget.type == ChargingStationType.private
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    spacing: 5,
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .grey4,
                                                        ),
                                                        child: Icon(
                                                          size: 30,
                                                          Icons
                                                              .settings_input_hdmi,
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Type 2',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    spacing: 5,
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .grey4,
                                                        ),
                                                        child: Icon(
                                                          size: 30,
                                                          Icons.bolt,
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        '11 kW',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    spacing: 5,
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .grey4,
                                                        ),
                                                        child: Icon(
                                                          size: 30,
                                                          Icons.paid,
                                                          color: context
                                                              .theme
                                                              .appColors
                                                              .primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        '2 SEK/kWh',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 20.0,
                                                    ),
                                                child: Divider(
                                                  height: 1,
                                                  color: context
                                                      .theme
                                                      .appColors
                                                      .grey3,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              LineCardWidget(
                                                label: 'Choose Time Slot',
                                              ),
                                              SizedBox(height: 30),
                                              Text(
                                                'Notes'.toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: context
                                                      .theme
                                                      .appColors
                                                      .grey1,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: BoxBorder.all(
                                                    color: context
                                                        .theme
                                                        .appColors
                                                        .grey3,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            15.0,
                                                          ),
                                                      child: Text(
                                                        'Charger located on the left side of the house. See picture, 100% solar power',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 200),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                spacing: 5,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .grey4,
                                                    ),
                                                    child: Icon(
                                                      size: 30,
                                                      Icons.settings_input_hdmi,
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .primary,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Type 2',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                spacing: 5,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .grey4,
                                                    ),
                                                    child: Icon(
                                                      size: 30,
                                                      Icons.bolt,
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .primary,
                                                    ),
                                                  ),
                                                  Text(
                                                    '11 kW',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                spacing: 5,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .grey4,
                                                    ),
                                                    child: Icon(
                                                      size: 30,
                                                      Icons.paid,
                                                      color: context
                                                          .theme
                                                          .appColors
                                                          .primary,
                                                    ),
                                                  ),
                                                  Text(
                                                    '2 SEK/kWh',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: context.theme.appColors.grey3,
                                      ),
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
                ),
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
                      bottom: 34.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: WattMainButton(
                            icon: Icon(Icons.phone),
                            label: 'Contact',
                            backgroundColor: context.theme.appColors.background,
                            iconColor: context.theme.appColors.onSurface,
                            textColor: context.theme.appColors.onSurface,
                            buttonShadow: context.theme.appColors.onSecondary
                                .withAlpha(38),
                            onPressed: () {
                              _showContactOptions(context);
                            },
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: WattMainButton(
                            label: 'Save',
                            onPressed: () {
                              // Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Allows custom shapes/colors
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              // bottom: 34,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.appColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Column(
                          spacing: 5,
                          children: [
                            Text(
                              "Phone number",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "046-56-5678904",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Call",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Send SMS",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Send email",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                WattWhiteButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
