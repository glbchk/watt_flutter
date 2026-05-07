import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:watt/presentation/menu_pages/bookings_page/components/booking_card_widget.dart';
import 'package:watt/presentation/menu_pages/bookings_page/components/past_booking_card_widget.dart';
import 'package:watt/presentation/menu_pages/bookings_page/sub_pages/past_booking_details_page.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_cubit.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/bloc/reservations_state.dart';
import 'package:watt/presentation/menu_pages/my_charging_reservations_page/sub_pages/charging_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ReservationsCubit>().fetchUpcomingReservationsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsCubit, ReservationsState>(
      builder: (context, state) {
        final upcomingReservations = state.upcomingReservations;
        final pastReservations = state.pastReservations;

        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return DefaultTabController(
          length: 2,
          child: DefaultAppBar(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: false,
            showAppBar: false,
            // appBarBackgroundColor: context.theme.appColors.transparent,
            // scaffoldBackgroundColor: context.theme.appColors.primary,
            // leading: BackButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  backgroundColor: context.theme.appColors.primary,
                  leading: BackButton(
                    color: context.theme.appColors.background,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(gradient: wattGradient),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 60,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 44),
                          Text(
                            'My charging reservations',
                            style: TextStyle(
                              color: context.theme.appColors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(64),
                    child: Container(
                      // color: context.theme.appColors.background,
                      decoration: BoxDecoration(
                        color: context.theme.appColors.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TabBar(
                          labelColor: context.theme.appColors.primary,
                          unselectedLabelColor: context.theme.appColors.grey1,
                          indicatorColor: const Color(0xFF007AFF),
                          tabs: const [
                            Tab(text: 'Upcoming'),
                            Tab(text: 'Past'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              body: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: upcomingReservations?.length ?? 0,
                    itemBuilder: (context, index) {
                      final upcomingReservation = upcomingReservations![index];

                      String stationName = "Loading...";
                      String stationAddress = "Loading...";

                      if (state.reservedChargingStations != null) {
                        for (var station in state.reservedChargingStations!) {
                          if (station.id == upcomingReservation.stationId) {
                            stationName =
                                station.chargingStationName ??
                                "Unknown Station";
                            stationAddress =
                                station.address ?? "Unknown Address";
                            break;
                          }
                        }
                      }

                      final scheduledTime =
                          StringHelperMethods.convertToOneSlot(
                            upcomingReservation.selectedTimes ?? [],
                          );

                      DateTime parsedDate = DateTime.parse(
                        upcomingReservation.date ?? '',
                      );

                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(parsedDate);

                      final time =
                          StringHelperMethods.calculateTotalBookingMinutes(
                            upcomingReservation.selectedTimes,
                          );

                      return BookingCardWidget(
                        chargingStationName: stationName,
                        dateOfBooking: formattedDate,
                        chargingStationTimeSlot: scheduledTime,
                        chargingStationAddress: stationAddress,
                        negativeLabel: 'Cancel reservation',
                        onPressedReject: () {
                          print(upcomingReservation.id);
                          context
                              .read<ReservationsCubit>()
                              .stopChargingOrCancelReservation(
                                upcomingReservation,
                              );
                        },
                        positiveLabel: 'Start charging',
                        positiveButtonColor: context.theme.appColors.primary,
                        onPressedAccept: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChargingPage(
                                reservation: upcomingReservation,
                                duration: Duration(minutes: time),
                              ),
                            ),
                          );
                        },
                        onPressedContactUser: () {
                          UiHelperMethods.showContactOptions(context);
                        },
                      );
                    },
                  ),

                  ListView.builder(
                    itemCount: pastReservations?.length ?? 0,
                    itemBuilder: (context, index) {
                      final pastReservation = pastReservations![index];

                      String stationName = "Loading...";
                      String? startTime = "Loading...";
                      String? endTime = "Loading...";

                      if (state.reservedChargingStations != null) {
                        for (var station in state.reservedChargingStations!) {
                          if (station.id == pastReservation.stationId) {
                            stationName =
                                station.chargingStationName ??
                                "Unknown Station";
                            startTime = StringHelperMethods.convertToStartTime(
                              pastReservation.date ?? '',
                              pastReservation.selectedTimes ?? [],
                            );
                            endTime = StringHelperMethods.convertToEndTime(
                              pastReservation.date ?? '',
                              pastReservation.selectedTimes ?? [],
                            );
                            // DateTime dateTime = DateTime.parse(rawDate);
                            //
                            // String formattedDate = DateFormat('yyyy-MM-dd, HH:mm').format(dateTime);
                            //
                            // print(formattedDate);

                            // startTime = station.address ?? "Unknown Address";
                            break;
                          }
                        }
                      }

                      return PastBookingCardWidget(
                        customerName: stationName,
                        startTimeOfBooking: startTime ?? '',
                        endTimeOfBooking: endTime ?? '',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PastBookingDetailsPage(),
                            ),
                          );
                        },
                      );
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
