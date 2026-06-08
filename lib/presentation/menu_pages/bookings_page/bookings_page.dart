import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:watt/presentation/menu_pages/bookings_page/bloc/bookings_cubit.dart';
import 'package:watt/presentation/menu_pages/bookings_page/bloc/bookings_state.dart';
import 'package:watt/presentation/menu_pages/bookings_page/components/booking_card_widget.dart';
import 'package:watt/presentation/menu_pages/bookings_page/components/past_booking_card_widget.dart';
import 'package:watt/presentation/menu_pages/bookings_page/sub_pages/past_booking_details_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_methods/string_helper_methods.dart';
import 'package:watt/utils/global_methods/ui_helper_methods.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();

    context.read<BookingsCubit>().fetchUpcomingAndPastBookingsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        final upcomingBookings = state.upcomingBookings;
        final pastBookings = state.pastBookings;

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
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 210.0,
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
                      decoration: BoxDecoration(
                        color: context.theme.appColors.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 10.0,
                          right: 20.0,
                        ),
                        child: TabBar(
                          tabAlignment: TabAlignment.fill,
                          labelColor: context.theme.appColors.primary,
                          unselectedLabelColor: context.theme.appColors.grey1,
                          indicatorColor: const Color(0xFF007AFF),
                          indicatorWeight: 2.0,
                          dividerColor: context.theme.appColors.grey1,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: upcomingBookings?.length ?? 0,
                      itemBuilder: (context, index) {
                        final upcomingBooking = upcomingBookings![index];

                        String stationName = "Loading...";
                        String stationAddress = "Loading...";

                        if (state.bookedChargingStations != null) {
                          for (var station in state.bookedChargingStations!) {
                            if (station.id == upcomingBooking.stationId) {
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
                              upcomingBooking.selectedTimes ?? [],
                            );

                        DateTime parsedDate = DateTime.parse(
                          upcomingBooking.date ?? '',
                        );

                        String formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(parsedDate);

                        ///TODO: FIX THIS
                        final time =
                            StringHelperMethods.calculateTotalBookingMinutes(
                              upcomingBooking.selectedTimes,
                            );

                        return BookingCardWidget(
                          chargingStationName: stationName,
                          dateOfReservation: formattedDate,
                          chargingStationTimeSlot: scheduledTime,
                          chargingStationAddress: stationAddress,
                          negativeLabel: 'Cancel reservation',
                          onPressedReject: () {
                            ///TODO: FIX THIS
                            print(upcomingBooking.id);
                            // context
                            //     .read<BookingsCubit>()
                            //     .stopChargingOrCancelReservation(
                            //   upcomingBooking,
                            // );
                          },
                          positiveLabel: 'Start charging',
                          positiveButtonColor: context.theme.appColors.primary,
                          onPressedAccept: () {
                            ///TODO: FIX THIS
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => BlocProvider.value(
                            //       value: context.read<BookingsCubit>(),
                            //       child:
                            //       ChargingTestPage<
                            //           ReservationsCubit,
                            //           ReservationsState
                            //       >(
                            //         reservation: upcomingBooking,
                            //         duration: Duration(minutes: time),
                            //         onInit: (cubit) => cubit
                            //             .fetchOneUpcomingReservedChargingStation(
                            //           upcomingBooking.stationId ??
                            //               '',
                            //         ),
                            //         onStopCharging: (cubit, reservation) =>
                            //             cubit
                            //                 .stopChargingOrCancelReservation(
                            //               reservation,
                            //             ),
                            //       ),
                            //     ),
                            //   ),
                            // );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => ChargingPage(
                            //       reservation: upcomingReservation,
                            //       duration: Duration(minutes: time),
                            //     ),
                            //   ),
                            // );
                          },
                          onPressedContactUser: () {
                            UiHelperMethods.showContactOptions(context);
                          },
                        );
                      },
                    ),
                  ),

                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: pastBookings?.length ?? 0,
                      itemBuilder: (context, index) {
                        final pastReservation = pastBookings![index];

                        String stationName = "Loading...";
                        String? startTime = "Loading...";
                        String? endTime = "Loading...";
                        print('station id: ${pastReservation.stationId}');

                        for (var station in state.bookedChargingStations!) {
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
                            break;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: PastReservationCardWidget(
                            customerName: stationName,
                            startTimeOfReservation: startTime ?? '',
                            endTimeOfReservation: endTime ?? '',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PastBookingDetailsPage(),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
